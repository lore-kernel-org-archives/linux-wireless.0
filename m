Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:42724 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab0CUKrI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Mar 2010 06:47:08 -0400
From: Kel Modderman <kel@otaku42.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] crda: do not embed crypto data when USE_OPENSSL=1
Date: Sun, 21 Mar 2010 20:46:52 +1000
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <201003050008.51066.kel@otaku42.de> <201003060059.42588.kel@otaku42.de> <1268035735.3819.17.camel@jlt3.sipsolutions.net>
In-Reply-To: <1268035735.3819.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003212046.52337.kel@otaku42.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 March 2010 18:08:55 Johannes Berg wrote:
> On Sat, 2010-03-06 at 00:59 +1000, Kel Modderman wrote:
> 
> > I am obviously having hard time clearly communicating what I think is wrong,
> 
> Yes.
> 
> > so attached is 2 files demonstrating the problem with step by step reproducible
> > commands with output. regdb-upgrade-does-not-work.txt shows the current
> > behaviour which must be improved, regdb-upgrade-does-work.txt shows
> > the behaviour with my patch applied. The patch which was used is also attached.
> 
> That isn't helping, we don't want to do your work of digging through :)
> 
> The building-in keys code should NOT be removed, it should be possible
> to build in keys AND use external keys (and I still think the external
> key code should be optional since it is _quite_ different from internal
> keys).

I'd prefer to use external keys only. If the correct paths are searched I
don't see any need to embed the pubkey data into binary.

> 
> What exactly happens when you build in keys and use external ones? The
> code I originally wrote should try to validate the database using all
> available keys, it seems like that was broken and you're trying to fix
> the symptom rather than the cause.
> 

I fucked up the subject and got two issues all mixed up. The issue which is
most important is that crda should search PUBKEY_DIR (eg. /lib/crda/pubkeys)
as well as the so called RUNTIME_PUBKEY_DIR (/etc/wireless-regdb/pubkeys)
because when wireless-regdb is updated it will install any new custom pubkeys
to PUBKEY_DIR and crda is still able to verify the new regulatory.bin after
loading the new pubkey at runtime. Attached a new patch.

Thanks, Kel.

--- a/Makefile
+++ b/Makefile
@@ -30,7 +30,8 @@ all: all_noverify verify
 all_noverify: crda intersect regdbdump
 
 ifeq ($(USE_OPENSSL),1)
-CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\" `pkg-config --cflags openssl`
+CFLAGS += -DPUBKEY_DIR=\"$(PUBKEY_DIR)\" -DRUNTIME_PUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\"
+CFLAGS += -DUSE_OPENSSL `pkg-config --cflags openssl`
 LDLIBS += `pkg-config --libs openssl`
 
 reglib.o: keys-ssl.c
--- a/reglib.c
+++ b/reglib.c
@@ -38,6 +38,40 @@ void *crda_get_file_ptr(__u8 *db, int db
 	return (void *)(db + p);
 }
 
+#ifdef USE_OPENSSL
+static int crda_pubkeydir_verification(const char *dir, __u8 *hash, __u8 *db,
+				       int dblen, int siglen)
+{
+	RSA *rsa;
+	DIR *pubkey_dir;
+	struct dirent *nextfile;
+	FILE *keyfile;
+	char filename[PATH_MAX];
+	int retv = 0;
+
+	if ((pubkey_dir = opendir(dir))) {
+		while (!retv && (nextfile = readdir(pubkey_dir))) {
+			snprintf(filename, PATH_MAX, "%s/%s", dir,
+				nextfile->d_name);
+			if ((keyfile = fopen(filename, "rb"))) {
+				rsa = PEM_read_RSA_PUBKEY(keyfile,
+					NULL, NULL, NULL);
+				if (rsa)
+					retv = RSA_verify(NID_sha1, hash,
+						SHA_DIGEST_LENGTH,
+						db + dblen, siglen,
+						rsa) == 1;
+				RSA_free(rsa);
+				fclose(keyfile);
+			}
+		}
+		closedir(pubkey_dir);
+	}
+
+	return retv;
+}
+#endif
+
 /*
  * Checks the validity of the signature found on the regulatory
  * database against the array 'keys'. Returns 1 if there exists
@@ -51,10 +85,6 @@ int crda_verify_db_signature(__u8 *db, i
 	__u8 hash[SHA_DIGEST_LENGTH];
 	unsigned int i;
 	int ok = 0;
-	DIR *pubkey_dir;
-	struct dirent *nextfile;
-	FILE *keyfile;
-	char filename[PATH_MAX];
 
 	if (SHA1(db, dblen, hash) != hash) {
 		fprintf(stderr, "Failed to calculate SHA1 sum.\n");
@@ -78,22 +108,12 @@ int crda_verify_db_signature(__u8 *db, i
 		rsa->n = NULL;
 		RSA_free(rsa);
 	}
-	if (!ok && (pubkey_dir = opendir(PUBKEY_DIR))) {
-		while (!ok && (nextfile = readdir(pubkey_dir))) {
-			snprintf(filename, PATH_MAX, "%s/%s", PUBKEY_DIR,
-				nextfile->d_name);
-			if ((keyfile = fopen(filename, "rb"))) {
-				rsa = PEM_read_RSA_PUBKEY(keyfile,
-					NULL, NULL, NULL);
-				if (rsa)
-					ok = RSA_verify(NID_sha1, hash, SHA_DIGEST_LENGTH,
-						db + dblen, siglen, rsa) == 1;
-				RSA_free(rsa);
-				fclose(keyfile);
-			}
-		}
-		closedir(pubkey_dir);
-	}
+	if (!ok)
+		ok = crda_pubkeydir_verification(PUBKEY_DIR, hash, db,
+						 dblen, siglen);
+	if (!ok)
+		ok = crda_pubkeydir_verification(RUNTIME_PUBKEY_DIR, hash, db,
+						 dblen, siglen);
 #endif
 
 #ifdef USE_GCRYPT
---
