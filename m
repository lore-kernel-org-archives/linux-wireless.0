Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:47048 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0CEO7z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 09:59:55 -0500
From: Kel Modderman <kel@otaku42.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] crda: do not embed crypto data when USE_OPENSSL=1
Date: Sat, 6 Mar 2010 00:59:42 +1000
Cc: linux-wireless@vger.kernel.org
References: <201003050008.51066.kel@otaku42.de> <201003051156.11922.kel@otaku42.de> <20100305040853.GA4640@tuxdriver.com>
In-Reply-To: <20100305040853.GA4640@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_exRkLn4zd+i8rvK"
Message-Id: <201003060059.42588.kel@otaku42.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_exRkLn4zd+i8rvK
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi John,

On Friday 05 March 2010 14:08:53 John W. Linville wrote:
> On Fri, Mar 05, 2010 at 11:56:11AM +1000, Kel Modderman wrote:
> > On Friday 05 March 2010 11:37:22 John W. Linville wrote:
> > > On Fri, Mar 05, 2010 at 10:27:03AM +1000, Kel Modderman wrote:
> > > > On Friday 05 March 2010 01:31:28 John W. Linville wrote:
> > > > > On Fri, Mar 05, 2010 at 12:08:50AM +1000, Kel Modderman wrote:
> 
> > > > > > This allows wireless-regdb to be built from source and upgraded independently
> > > > > > of crda and is _crucial_ for distributions who want to build their own
> > > > > > regulatory.bin.
> > > > > 
> > > > > I don't understand -- isn't this possible already?
> > > > 
> > > > No.
> > > 
> > > Perhaps you could use a few more words?  It seems to me that what
> > > limits you is the policies of some distributions.  Certainly crda
> > > and wireless-regdb can be maintained separately so long as the key
> > > doesn't change between builds or with alternate keys installed in
> > > the proper locations.  Am I missing something?
> > 
> > Yes you are missing something. Its not the policy of my distribution which
> > is limiting its the design of the crda/wireless-regdb build systems.
> > 
> > Now that openssl support allows reading pubkeys at runtime, the  embedding
> > of crypto data into binaries can be totally removed when built with openssl.
> 
> I don't think anyone said that this change could not be made.
> I merely challenged the flawed reasoning you asserted for its need.
> 
> > wireless-regdb can be built from source, when it does so it generates a new
> > custom key which is installed to /lib/crda/pubkeys/<key>. Your key is also
> > installed here, oh but hang on, its also embedded into the binary so why bother
> > installing it at all? Alright, so we can manually move our custom generated
> > key from /lib/crda/pubkeys/<key> to /etc/wireless-regdb/pubkeys/<key> and things
> > will probably be okay next time we build wireless-regdb and upgrade it
> > independently of crda, except for:
> 
> Why would you need to move it?  Did someone break the code that uses
> regdb_paths in crda.c?  Does PUBKEY_DIR not work?
> 
> > 1. we now have /lib/crda/pubkeys/linville.pub.pem for no reason at all
> 
> If you don't want my key (or any other) in your binary then simply
> delete it from crda/pubkeys in your build scripts...?
> 
> > 2. the distribution is installing to /etc/wireless-regdb/pubkeys/ which should
> >    be reserved for the admin
> 
> "make PUBKEY_DIR=/lib/crda/pubkeys"?
> 
> > 3. you're maintaining a bunch of useless code which embeds openssl data into
> >    binaries when you do not have to
> 
> See rebuttal to #1...just because you don't use some functionality
> doesn't mean no one else wants it or uses it.
> 
> > These 3 points is what my patch attempts to address.
> 
> It seems to me that you address the points by simply removing
> functionality rather than using other means that already exist to
> address the same concerns.

I am obviously having hard time clearly communicating what I think is wrong,
so attached is 2 files demonstrating the problem with step by step reproducible
commands with output. regdb-upgrade-does-not-work.txt shows the current
behaviour which must be improved, regdb-upgrade-does-work.txt shows
the behaviour with my patch applied. The patch which was used is also attached.

The steps simulate the independent upgrade/re-installation of wireless-regdb after
rebuilding regulatory.bin and signing with a new key. This is a simulation of
the expected upgrade path when wireless-regdb and crda are packaged separately
and one-time ssl keys are used when building wireless-regdb.

I hope that these logs, along with the patch, help show that I am not removing
any current interface from crda, just trying to fix up its current ones.

Thanks, Kel.

--Boundary-00=_exRkLn4zd+i8rvK
Content-Type: text/x-patch;
  charset="UTF-8";
  name="openssl_runtime_verification_tuneup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="openssl_runtime_verification_tuneup.patch"

When USE_OPENSSL=1 do not embed crypto data into binary, use the PUBKEY_DIR
variable just as it is when USE_GCRYPT=1 and just load certs from PUBKEY_DIR
for signature verification at runtime. Remove ssl support from
utils/key2pub.py.

This allows wireless-regdb to be built from source and upgraded independently
of crda and is _crucial_ for distributions who want to build their own
regulatory.bin.

When verification fails provide information about the PUBKEY_DIR variable.

Fix typo (s/make noverify/make all_noverify/).

Signed-off-by: Kel Modderman <kel@otaku42.de>
---
--- a/Makefile
+++ b/Makefile
@@ -16,13 +16,6 @@ UDEV_LEVEL=$(CRDA_UDEV_LEVEL)-
 # a different location.
 UDEV_RULE_DIR?=/lib/udev/rules.d/
 
-# If your distribution requires a custom pubkeys dir
-# you must update this variable to reflect where the
-# keys are put when building. For example you can run
-# with make PUBKEY_DIR=/usr/lib/crda/pubkeys
-PUBKEY_DIR?=pubkeys
-RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
-
 CFLAGS += -Wall -g
 
 all: all_noverify verify
@@ -30,17 +23,24 @@ all: all_noverify verify
 all_noverify: crda intersect regdbdump
 
 ifeq ($(USE_OPENSSL),1)
-CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\" `pkg-config --cflags openssl`
+PUBKEY_DIR?=$(PREFIX)/lib/crda/pubkeys
+RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
+CFLAGS += -DUSE_OPENSSL `pkg-config --cflags openssl`
+CFLAGS += -DPUBKEY_DIR=\"$(PUBKEY_DIR)\" -DALT_PUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\"
 LDLIBS += `pkg-config --libs openssl`
 
-reglib.o: keys-ssl.c
-
 else
+PUBKEY_DIR?=pubkeys
 CFLAGS += -DUSE_GCRYPT
 LDLIBS += -lgcrypt
 
 reglib.o: keys-gcrypt.c
 
+keys-gcrypt.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
+	$(NQ) '  GEN ' $@
+	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
+	$(Q)./utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem) $@
+
 endif
 MKDIR ?= mkdir -p
 INSTALL ?= install
@@ -82,15 +82,10 @@ $(REG_BIN):
 	$(NQ) $(REG_GIT)
 	$(NQ)
 	$(NQ) "Once cloned (no need to build) cp regulatory.bin to $(REG_BIN)"
-	$(NQ) "Use \"make noverify\" to disable verification"
+	$(NQ) "Use \"make all_noverify\" to disable verification"
 	$(NQ)
 	$(Q) exit 1
 
-keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
-	$(NQ) '  GEN ' $@
-	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
-	$(Q)./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
-
 %.o: %.c regdb.h
 	$(NQ) '  CC  ' $@
 	$(Q)$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<
@@ -109,7 +104,15 @@ intersect: reglib.o intersect.o print-re
 
 verify: $(REG_BIN) regdbdump
 	$(NQ) '  CHK  $(REG_BIN)'
-	$(Q)./regdbdump $(REG_BIN) >/dev/null
+	@if ! ./regdbdump $(REG_BIN) >/dev/null; then \
+		echo; \
+		echo "If your distribution requires a custom pubkeys dir you must set"; \
+		echo "PUBKEY_DIR to path where the keys are installed by wireless-regdb."; \
+		echo "For example:"; \
+		echo "    make PUBKEY_DIR=/lib/crda/pubkeys"; \
+		echo; \
+		exit 1; \
+	fi
 
 %.gz: %
 	@$(NQ) ' GZIP' $<
--- a/reglib.c
+++ b/reglib.c
@@ -18,10 +18,6 @@
 
 #include "reglib.h"
 
-#ifdef USE_OPENSSL
-#include "keys-ssl.c"
-#endif
-
 #ifdef USE_GCRYPT
 #include "keys-gcrypt.c"
 #endif
@@ -49,7 +45,6 @@ int crda_verify_db_signature(__u8 *db, i
 #ifdef USE_OPENSSL
 	RSA *rsa;
 	__u8 hash[SHA_DIGEST_LENGTH];
-	unsigned int i;
 	int ok = 0;
 	DIR *pubkey_dir;
 	struct dirent *nextfile;
@@ -61,26 +56,26 @@ int crda_verify_db_signature(__u8 *db, i
 		goto out;
 	}
 
-	for (i = 0; (i < sizeof(keys)/sizeof(keys[0])) && (!ok); i++) {
-		rsa = RSA_new();
-		if (!rsa) {
-			fprintf(stderr, "Failed to create RSA key.\n");
-			goto out;
+	if ((pubkey_dir = opendir(PUBKEY_DIR))) {
+		while (!ok && (nextfile = readdir(pubkey_dir))) {
+			snprintf(filename, PATH_MAX, "%s/%s", PUBKEY_DIR,
+				nextfile->d_name);
+			if ((keyfile = fopen(filename, "rb"))) {
+				rsa = PEM_read_RSA_PUBKEY(keyfile,
+					NULL, NULL, NULL);
+				if (rsa)
+					ok = RSA_verify(NID_sha1, hash, SHA_DIGEST_LENGTH,
+						db + dblen, siglen, rsa) == 1;
+				RSA_free(rsa);
+				fclose(keyfile);
+			}
 		}
-
-		rsa->e = &keys[i].e;
-		rsa->n = &keys[i].n;
-
-		ok = RSA_verify(NID_sha1, hash, SHA_DIGEST_LENGTH,
-				db + dblen, siglen, rsa) == 1;
-
-		rsa->e = NULL;
-		rsa->n = NULL;
-		RSA_free(rsa);
+		closedir(pubkey_dir);
 	}
-	if (!ok && (pubkey_dir = opendir(PUBKEY_DIR))) {
+
+	if (!ok && (pubkey_dir = opendir(ALT_PUBKEY_DIR))) {
 		while (!ok && (nextfile = readdir(pubkey_dir))) {
-			snprintf(filename, PATH_MAX, "%s/%s", PUBKEY_DIR,
+			snprintf(filename, PATH_MAX, "%s/%s", ALT_PUBKEY_DIR,
 				nextfile->d_name);
 			if ((keyfile = fopen(filename, "rb"))) {
 				rsa = PEM_read_RSA_PUBKEY(keyfile,
--- a/utils/key2pub.py
+++ b/utils/key2pub.py
@@ -9,81 +9,6 @@ except ImportError, e:
        sys.stderr.write('On Debian GNU/Linux the package is called "python-m2crypto".\n')
        sys.exit(1)
 
-def print_ssl_64(output, name, val):
-    while val[0] == '\0':
-        val = val[1:]
-    while len(val) % 8:
-        val = '\0' + val
-    vnew = []
-    while len(val):
-        vnew.append((val[0], val[1], val[2], val[3], val[4], val[5], val[6], val[7]))
-        val = val[8:]
-    vnew.reverse()
-    output.write('static BN_ULONG %s[%d] = {\n' % (name, len(vnew)))
-    idx = 0
-    for v1, v2, v3, v4, v5, v6, v7, v8 in vnew:
-        if not idx:
-            output.write('\t')
-        output.write('0x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x, ' % (ord(v1), ord(v2), ord(v3), ord(v4), ord(v5), ord(v6), ord(v7), ord(v8)))
-        idx += 1
-        if idx == 2:
-            idx = 0
-            output.write('\n')
-    if idx:
-        output.write('\n')
-    output.write('};\n\n')
-
-def print_ssl_32(output, name, val):
-    while val[0] == '\0':
-        val = val[1:]
-    while len(val) % 4:
-        val = '\0' + val
-    vnew = []
-    while len(val):
-        vnew.append((val[0], val[1], val[2], val[3], ))
-        val = val[4:]
-    vnew.reverse()
-    output.write('static BN_ULONG %s[%d] = {\n' % (name, len(vnew)))
-    idx = 0
-    for v1, v2, v3, v4 in vnew:
-        if not idx:
-            output.write('\t')
-        output.write('0x%.2x%.2x%.2x%.2x, ' % (ord(v1), ord(v2), ord(v3), ord(v4)))
-        idx += 1
-        if idx == 4:
-            idx = 0
-            output.write('\n')
-    if idx:
-        output.write('\n')
-    output.write('};\n\n')
-
-def print_ssl(output, name, val):
-    import struct
-    if len(struct.pack('@L', 0)) == 8:
-        return print_ssl_64(output, name, val)
-    else:
-        return print_ssl_32(output, name, val)
-
-def print_ssl_keys(output, n):
-    output.write(r'''
-struct pubkey {
-	struct bignum_st e, n;
-};
-
-#define KEY(data) {				\
-	.d = data,				\
-	.top = sizeof(data)/sizeof(data[0]),	\
-}
-
-#define KEYS(e,n)	{ KEY(e), KEY(n), }
-
-static struct pubkey keys[] = {
-''')
-    for n in xrange(n + 1):
-        output.write('	KEYS(e_%d, n_%d),\n' % (n, n))
-    output.write('};\n')
-    pass
-
 def print_gcrypt(output, name, val):
     while val[0] == '\0':
         val = val[1:]
@@ -118,24 +43,10 @@ static const struct key_params keys[] =
     for n in xrange(n + 1):
         output.write('	KEYS(e_%d, n_%d),\n' % (n, n))
     output.write('};\n')
-    
-
-modes = {
-    '--ssl': (print_ssl, print_ssl_keys),
-    '--gcrypt': (print_gcrypt, print_gcrypt_keys),
-}
 
-try:
-    mode = sys.argv[1]
-    files = sys.argv[2:-1]
-    outfile = sys.argv[-1]
-except IndexError:
-    mode = None
-
-if not mode in modes:
-    print 'Usage: %s [%s] input-file... output-file' % (sys.argv[0], '|'.join(modes.keys()))
-    sys.exit(2)
 
+files = sys.argv[1:-1]
+outfile = sys.argv[-1]
 output = open(outfile, 'w')
 
 # load key
@@ -146,8 +57,8 @@ for f in files:
     except RSA.RSAError:
         key = RSA.load_key(f)
 
-    modes[mode][0](output, 'e_%d' % idx, key.e[4:])
-    modes[mode][0](output, 'n_%d' % idx, key.n[4:])
+    print_gcrypt(output, 'e_%d' % idx, key.e[4:])
+    print_gcrypt(output, 'n_%d' % idx, key.n[4:])
     idx += 1
 
-modes[mode][1](output, idx - 1)
+print_gcrypt_keys(output, idx - 1)

--Boundary-00=_exRkLn4zd+i8rvK
Content-Type: text/plain;
  charset="UTF-8";
  name="regdb-upgrade-does-not-work.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="regdb-upgrade-does-not-work.txt"

# wget -q -O/tmp/wireless-regdb-2009.11.25.tar.bz2 http://wireless.kernel.org/download/wireless-regdb/wireless-regdb-2009.11.25.tar.bz2    
# wget -q -O/tmp/crda-1.1.1.tar.bz2 http://wireless.kernel.org/download/crda/crda-1.1.1.tar.bz2                                            
# tar -C /tmp -xjf /tmp/wireless-regdb-2009.11.25.tar.bz2                                                                                  
# make -C /tmp/wireless-regdb-2009.11.25 all                                                                                               
make: Entering directory `/tmp/wireless-regdb-2009.11.25'                                                                                  
Generating private key for root...                                                                                                         
openssl genrsa -out ~/.wireless-regdb-root.key.priv.pem 2048                                                                               
Generating RSA private key, 2048 bit long modulus                                                                                          
...................................................................................................................................................................................+++                                                                                                    
................................................................+++                                                                          
e is 65537 (0x10001)                                                                                                                         
Generating public key for root...                                                                                                            
openssl rsa -in ~/.wireless-regdb-root.key.priv.pem -out root.key.pub.pem -pubout -outform PEM                                               
writing RSA key                                                                                                                              
Generating regulatory.bin digitally signed by root...                                                                                        
./db2bin.py regulatory.bin db.txt ~/.wireless-regdb-root.key.priv.pem                                                                        
make: Leaving directory `/tmp/wireless-regdb-2009.11.25'                                                                                     
# make -C /tmp/wireless-regdb-2009.11.25 install                                                                                             
make: Entering directory `/tmp/wireless-regdb-2009.11.25'                                                                                    
gzip < regulatory.bin.5 > regulatory.bin.5.gz                                                                                                
install -m 755 -d //usr/lib/crda                                                                                                             
install -m 755 -d //usr/lib/crda/pubkeys                                                                                                     
if [ -f .custom ]; then \                                                                                                                    
                install -m 644 -t //usr/lib/crda/pubkeys/ root.key.pub.pem; \                                                                
        fi                                                                                                                                   
install -m 644 -t //usr/lib/crda/pubkeys/ linville.key.pub.pem                                                                               
install -m 644 -t //usr/lib/crda/ regulatory.bin                                                                                             
install -m 755 -d //usr/share/man//man5/                                                                                                     
install -m 644 -t //usr/share/man//man5/ regulatory.bin.5.gz                                                                                 
make: Leaving directory `/tmp/wireless-regdb-2009.11.25'                                                                                     
# tar -C /tmp -xjf /tmp/crda-1.1.1.tar.bz2                                                                                                   
# make -C /tmp/crda-1.1.1 all USE_OPENSSL=1 PUBKEY_DIR=/usr/lib/crda/pubkeys/                                                                
make: Entering directory `/tmp/crda-1.1.1'                                                                                                   
  GEN  keys-ssl.c                                                                                                                            
  Trusted pubkeys: /usr/lib/crda/pubkeys//linville.key.pub.pem /usr/lib/crda/pubkeys//root.key.pub.pem                                       
  CC   reglib.o                                                                                                                              
  CC   crda.o                                                                                                                                
  LD   crda                                                                                                                                  
  CC   intersect.o                                                                                                                           
  CC   print-regdom.o                                                                                                                        
  LD   intersect                                                                                                                             
  CC   regdbdump.o                                                                                                                           
  LD   regdbdump
  CHK  /usr/lib/crda/regulatory.bin
make: Leaving directory `/tmp/crda-1.1.1'
# make -C /tmp/crda-1.1.1 install USE_OPENSSL=1 PUBKEY_DIR=/usr/lib/crda/pubkeys/
make: Entering directory `/tmp/crda-1.1.1'
 GZIP crda.8
 GZIP regdbdump.8
  INSTALL  crda
  INSTALL  regdbdump
  INSTALL  85-regulatory.rules
  INSTALL  crda.8.gz
  INSTALL  regdbdump.8.gz
make: Leaving directory `/tmp/crda-1.1.1'
# rm -v /root/.wireless-regdb-root.key.priv.pem
removed `/root/.wireless-regdb-root.key.priv.pem'
# make -C /tmp/wireless-regdb-2009.11.25 all
make: Entering directory `/tmp/wireless-regdb-2009.11.25'
Generating private key for root...
openssl genrsa -out ~/.wireless-regdb-root.key.priv.pem 2048
Generating RSA private key, 2048 bit long modulus
...........................+++
.....................................+++
e is 65537 (0x10001)
Generating public key for root...
openssl rsa -in ~/.wireless-regdb-root.key.priv.pem -out root.key.pub.pem -pubout -outform PEM
writing RSA key
Generating regulatory.bin digitally signed by root...
./db2bin.py regulatory.bin db.txt ~/.wireless-regdb-root.key.priv.pem
make: Leaving directory `/tmp/wireless-regdb-2009.11.25'
# make -C /tmp/wireless-regdb-2009.11.25 install
make: Entering directory `/tmp/wireless-regdb-2009.11.25'
gzip < regulatory.bin.5 > regulatory.bin.5.gz
install -m 755 -d //usr/lib/crda
install -m 755 -d //usr/lib/crda/pubkeys
if [ -f .custom ]; then \
                install -m 644 -t //usr/lib/crda/pubkeys/ root.key.pub.pem; \
        fi
install -m 644 -t //usr/lib/crda/pubkeys/ linville.key.pub.pem
install -m 644 -t //usr/lib/crda/ regulatory.bin
install -m 755 -d //usr/share/man//man5/
install -m 644 -t //usr/share/man//man5/ regulatory.bin.5.gz
make: Leaving directory `/tmp/wireless-regdb-2009.11.25'
# regdbdump /usr/lib/crda/regulatory.bin
Database signature verification failed.

--Boundary-00=_exRkLn4zd+i8rvK
Content-Type: text/plain;
  charset="UTF-8";
  name="regdb-upgrade-does-work.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="regdb-upgrade-does-work.txt"

# wget -q -O/tmp/wireless-regdb-2009.11.25.tar.bz2 http://wireless.kernel.org/download/wireless-regdb/wireless-regdb-2009.11.25.tar.bz2      
# wget -q -O/tmp/crda-1.1.1.tar.bz2 http://wireless.kernel.org/download/crda/crda-1.1.1.tar.bz2                                              
# tar -C /tmp -xjf /tmp/wireless-regdb-2009.11.25.tar.bz2                                                                                    
# make -C /tmp/wireless-regdb-2009.11.25 all                                                                                                 
make: Entering directory `/tmp/wireless-regdb-2009.11.25'                                                                                    
Generating private key for root...                                                                                                           
openssl genrsa -out ~/.wireless-regdb-root.key.priv.pem 2048                                                                                 
Generating RSA private key, 2048 bit long modulus                                                                                            
..............+++                                                                                                                            
....................................................................................................................................................................................+++                                                                                                   
e is 65537 (0x10001)                                                                                                                         
Generating public key for root...                                                                                                            
openssl rsa -in ~/.wireless-regdb-root.key.priv.pem -out root.key.pub.pem -pubout -outform PEM                                               
writing RSA key                                                                                                                              
Generating regulatory.bin digitally signed by root...                                                                                        
./db2bin.py regulatory.bin db.txt ~/.wireless-regdb-root.key.priv.pem                                                                        
make: Leaving directory `/tmp/wireless-regdb-2009.11.25'                                                                                     
# make -C /tmp/wireless-regdb-2009.11.25 install                                                                                             
make: Entering directory `/tmp/wireless-regdb-2009.11.25'                                                                                    
gzip < regulatory.bin.5 > regulatory.bin.5.gz                                                                                                
install -m 755 -d //usr/lib/crda                                                                                                             
install -m 755 -d //usr/lib/crda/pubkeys                                                                                                     
if [ -f .custom ]; then \                                                                                                                    
                install -m 644 -t //usr/lib/crda/pubkeys/ root.key.pub.pem; \                                                                
        fi                                                                                                                                   
install -m 644 -t //usr/lib/crda/pubkeys/ linville.key.pub.pem                                                                               
install -m 644 -t //usr/lib/crda/ regulatory.bin                                                                                             
install -m 755 -d //usr/share/man//man5/                                                                                                     
install -m 644 -t //usr/share/man//man5/ regulatory.bin.5.gz                                                                                 
make: Leaving directory `/tmp/wireless-regdb-2009.11.25'                                                                                     
# tar -C /tmp -xjf /tmp/crda-1.1.1.tar.bz2                                                                                                   
# wget -q -O/tmp/crda.patch http://users.tpg.com.au/sigm/patches/openssl_runtime_verification_tuneup.patch                                   
# patch -d /tmp/crda-1.1.1 -p1 -i /tmp/crda.patch                                                                                            
patching file Makefile                                                                                                                       
patching file reglib.c                                                                                                                       
patching file utils/key2pub.py                                                                                                               
# make -C /tmp/crda-1.1.1 all USE_OPENSSL=1                                                                                                  
make: Entering directory `/tmp/crda-1.1.1'                                                                                                   
  CC   reglib.o                                                                                                                              
  CC   crda.o                                                                                                                                
  LD   crda                                                                                                                                  
  CC   intersect.o                                                                                                                           
  CC   print-regdom.o                                                                                                                        
  LD   intersect                                                                                                                             
  CC   regdbdump.o                                                                                                                           
  LD   regdbdump                                                                                                                             
  CHK  /usr/lib/crda/regulatory.bin                                                                                                          
make: Leaving directory `/tmp/crda-1.1.1'                                                                                                    
# make -C /tmp/crda-1.1.1 install USE_OPENSSL=1                                                                                              
make: Entering directory `/tmp/crda-1.1.1'                                                                                                   
 GZIP crda.8                                                                                                                                 
 GZIP regdbdump.8                                                                                                                            
  INSTALL  crda                                                                                                                              
  INSTALL  regdbdump                                                                                                                         
  INSTALL  85-regulatory.rules                                                                                                               
  INSTALL  crda.8.gz                                                                                                                         
  INSTALL  regdbdump.8.gz                                                                                                                    
make: Leaving directory `/tmp/crda-1.1.1'                                                                                                    
# rm -v /root/.wireless-regdb-root.key.priv.pem                                                                                              
removed `/root/.wireless-regdb-root.key.priv.pem'                                                                                            
# make -C /tmp/wireless-regdb-2009.11.25 all                                                                                                 
make: Entering directory `/tmp/wireless-regdb-2009.11.25'                                                                                    
Generating private key for root...                                                                                                           
openssl genrsa -out ~/.wireless-regdb-root.key.priv.pem 2048                                                                                 
Generating RSA private key, 2048 bit long modulus                                                                                            
.....................................+++                                                                                                     
.........................+++                                                                                                                 
e is 65537 (0x10001)                                                                                                                         
Generating public key for root...                                                                                                            
openssl rsa -in ~/.wireless-regdb-root.key.priv.pem -out root.key.pub.pem -pubout -outform PEM                                               
writing RSA key                                                                                                                              
Generating regulatory.bin digitally signed by root...                                                                                        
./db2bin.py regulatory.bin db.txt ~/.wireless-regdb-root.key.priv.pem                                                                        
make: Leaving directory `/tmp/wireless-regdb-2009.11.25'                                                                                     
# make -C /tmp/wireless-regdb-2009.11.25 install                                                                                             
make: Entering directory `/tmp/wireless-regdb-2009.11.25'                                                                                    
gzip < regulatory.bin.5 > regulatory.bin.5.gz                                                                                                
install -m 755 -d //usr/lib/crda                                                                                                             
install -m 755 -d //usr/lib/crda/pubkeys                                                                                                     
if [ -f .custom ]; then \                                                                                                                    
                install -m 644 -t //usr/lib/crda/pubkeys/ root.key.pub.pem; \                                                                
        fi                                                                                                                                   
install -m 644 -t //usr/lib/crda/pubkeys/ linville.key.pub.pem                                                                               
install -m 644 -t //usr/lib/crda/ regulatory.bin                                                                                             
install -m 755 -d //usr/share/man//man5/                                                                                                     
install -m 644 -t //usr/share/man//man5/ regulatory.bin.5.gz                                                                                 
make: Leaving directory `/tmp/wireless-regdb-2009.11.25'                                                                                     
# regdbdump /usr/lib/crda/regulatory.bin                                                                                                     
country 00:                                                                                                                                  
        (2402.000 - 2472.000 @ 40.000), (3.00, 20.00)                                                                                        
        (2457.000 - 2482.000 @ 20.000), (3.00, 20.00), PASSIVE-SCAN, NO-IBSS                                                                 
        (2474.000 - 2494.000 @ 20.000), (3.00, 20.00), NO-OFDM, PASSIVE-SCAN, NO-IBSS                                                        
        (5170.000 - 5250.000 @ 40.000), (3.00, 20.00), PASSIVE-SCAN, NO-IBSS                                                                 
        (5735.000 - 5835.000 @ 40.000), (3.00, 20.00), PASSIVE-SCAN, NO-IBSS
...

--Boundary-00=_exRkLn4zd+i8rvK--
