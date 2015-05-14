Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903AbbENPCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 11:02:35 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAB=NE6WQoq-Es+rVsLgagGLxwzGJAMh2jy08Bf1wuy45xqwnmA@mail.gmail.com>
References: <CAB=NE6WQoq-Es+rVsLgagGLxwzGJAMh2jy08Bf1wuy45xqwnmA@mail.gmail.com> <1431541436-17007-5-git-send-email-mcgrof@do-not-panic.com> <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com> <23142.1431615049@warthog.procyon.org.uk> <23172.1431615124@warthog.procyon.org.uk>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: dhowells@redhat.com, Ming Lei <ming.lei@canonical.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Paul Bolle <pebolle@tiscali.nl>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jlee@suse.com,
	Takashi Iwai <tiwai@suse.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Kees Cook <keescook@chromium.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC v2 4/6] scripts/sign-file.c: add support to only create signature file
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 14 May 2015 16:02:25 +0100
Message-ID: <9134.1431615745@warthog.procyon.org.uk> (sfid-20150514_170258_482394_7BEB0CEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:

> > Use "-d".  I added the flag but then never made it do anything.
> 
> Sure, but since this C file is not upstream, how about just squashing
> the commit with yours that adds the C file?

I've got various Tested-by's on that.

Anyway, I'm going to stack the attached patch on my branch if that's okay by
you...

David
---
commit 092c720a627b913918eb22f6700f189b34f70693
Author: Luis R. Rodriguez <mcgrof@suse.com>
Date:   Wed May 13 11:23:54 2015 -0700

    sign-file: Add option to only create signature file
    
    Make the -d option (which currently isn't actually wired to anything) write
    out the PKCS#7 message as per the -p option and then exit without either
    modifying the source or writing out a compound file of the source, signature
    and metadata.
    
    This will be useful when firmware signature support is added
    upstream as firmware will be left intact, and we'll only require
    the signature file. The descriptor is implicit by file extension
    and the file's own size.
    
    Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
    Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index 5b8a6dda3235..39aaabe89388 100755
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -86,13 +86,14 @@ int main(int argc, char **argv)
 	char *hash_algo = NULL;
 	char *private_key_name, *x509_name, *module_name, *dest_name;
 	bool save_pkcs7 = false, replace_orig;
+	bool sign_only = false;
 	unsigned char buf[4096];
 	unsigned long module_size, pkcs7_size;
 	const EVP_MD *digest_algo;
 	EVP_PKEY *private_key;
 	PKCS7 *pkcs7;
 	X509 *x509;
-	BIO *b, *bd, *bm;
+	BIO *b, *bd = NULL, *bm;
 	int opt, n;
 
 	ERR_load_crypto_strings();
@@ -102,6 +103,7 @@ int main(int argc, char **argv)
 		opt = getopt(argc, argv, "dp");
 		switch (opt) {
 		case 'p': save_pkcs7 = true; break;
+		case 'd': sign_only = true; save_pkcs7 = true; break;
 		case -1: break;
 		default: format();
 		}
@@ -148,8 +150,10 @@ int main(int argc, char **argv)
 	/* Open the destination file now so that we can shovel the module data
 	 * across as we read it.
 	 */
-	bd = BIO_new_file(dest_name, "wb");
-	ERR(!bd, "%s", dest_name);
+	if (!sign_only) {
+		bd = BIO_new_file(dest_name, "wb");
+		ERR(!bd, "%s", dest_name);
+	}
 
 	/* Digest the module data. */
 	OpenSSL_add_all_digests();
@@ -180,6 +184,9 @@ int main(int argc, char **argv)
 		BIO_free(b);
 	}
 
+	if (sign_only)
+		return 0;
+
 	/* Append the marker and the PKCS#7 message to the destination file */
 	ERR(BIO_reset(bm) < 0, "%s", module_name);
 	while ((n = BIO_read(bm, buf, sizeof(buf))),
