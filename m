Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbbGQQPE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:15:04 -0400
Subject: [PATCH 00/27] MODSIGN: Use PKCS#7 for module signatures
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:14:57 +0100
Message-ID: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk> (sfid-20150717_182443_865029_0D1DFADE)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Here's a set of patches that does the following:

 (1) Extracts both parts of an X.509 AuthorityKeyIdentifier (AKID)
     extension.  We already extract the bit that can match the
     subjectKeyIdentifier (SKID) of the parent X.509 cert, but we currently
     ignore the bits that can match the issuer and serialNumber.

     Looks up an X.509 cert by issuer and serialNumber if those are
     provided in the AKID.  If the keyIdentifier is also provided, checks
     that the subjectKeyIdentifier of the cert found matches that also.

     If no issuer and serialNumber are provided in the AKID, looks up an
     X.509 cert by SKID using the AKID keyIdentifier.

     This allows module signing to be done with certificates that don't
     have an SKID by which they can be looked up.

 (2) Makes use of the PKCS#7 facility to provide module signatures.

     sign-file is replaced with a program that generates a PKCS#7 message
     that has no X.509 certs embedded and that has detached data (the
     module content) and adds it onto the message with magic string and
     descriptor.

 (3) The PKCS#7 message supplies all the information that is needed to
     select the X.509 cert to be used to verify the signature by standard
     means (including selection of digest algorithm and public key
     algorithm).  No kernel-specific magic values are required.

 (4) Makes it possible to get sign-file to just write out a file containing
     the PKCS#7 signature blob.  This can be used for debugging and
     potentially for firmware signing.

 (5) Extracts the function that does PKCS#7 signature verification on a
     blob from the module signing code and put it somewhere more general so
     that other things, such as firmware signing, can make use of it
     without depending on module config options.

 (6) Adds support for CMS messages in place of PKCS#7 (they're very similar
     ASN.1) and makes sign-file create CMS messages instead of PKCS#7.
     This allows signatures to refer to the verifying key by X.509 cert
     SKID instead of X.509 cert issuer and serial number.

 (7) Provides support for providing a password/pin for an encrypted private
     key to sign-file.

 (8) Makes it possible to use PKCS#11 with sign-file, thus allowing the use
     of cryptographic hardware.

 (9) Overhauls the way the module signing key is handled.  If the name in
     CONFIG_MODULE_SIG_KEY is "signing_key.pem" then a key will be
     automatically generated and placed in the build directory.  If the
     name is different, autogeneration is suppressed and the file is
     presumed to be a PEM file containing both the private key and X.509
     certificate.

(10) Overhauls the way auxiliary trusted keys are added to the kernel.
     Files matching the pattern "*.x509" are no longer just gathered up and
     cat'd together.  Now CONFIG_SYSTEM_TRUSTED_KEYS must be set to point
     to a single PEM file containing a set of X.509 certs cat'd together if
     this facility is desired.

Note that the revised sign-file program no longer supports the "-s
<signature>" option to add an externally generated signature.  This is
deprecated in favour of using PKCS#11.  Note also that the format of the
signature file that would be passed to -s has changed.

David Woodhouse also has stated an intention to overhaul the makefile magic
he added to deal with quotes and quoting encountered when using CONFIG_*
option strings in the makefile.

The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=modsign-pkcs7

and are tagged with:

	modsign-pkcs7-20150717


Additionally, the last four patches are provisionally added to support
firmware signing and are added for comment since they depend on the
preceding set of patches.

(11) Add usage restriction markers to the extendedKeyUsage field of an
     X.509 certificate to indicate what may be checked with it.

(12) Parse the keyUsage extension of an X.509 certificate to detect CA keys
     that are used for key signing.

(13) Add a PKCS#7 authenticated attribute to hold the name of the firmware
     blob passed to request_key() so that this can be checked prior to
     permitting the load.

(14) Implement a key usage restrictions.  For instance, a keys specifically
     restricted to module signature checking may not be used to verify
     firmware blobs and a key specifically restricted to kexec image
     signature checking may not be used for checking the signature on an
     X.509 certificate.

     I have allowed that keys that have no restrictions noted can be used
     for anything other than firmware, but possibly this should be
     restricted further.

They can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=fwsign-pkcs7

and are tagged with:

	fwsign-pkcs7-20150717

David
---
David Howells (17):
      X.509: Extract both parts of the AuthorityKeyIdentifier
      X.509: Support X.509 lookup by Issuer+Serial form AuthorityKeyIdentifier
      PKCS#7: Allow detached data to be supplied for signature checking purposes
      MODSIGN: Provide a utility to append a PKCS#7 signature to a module
      MODSIGN: Use PKCS#7 messages as module signatures
      system_keyring.c doesn't need to #include module-internal.h
      MODSIGN: Extract the blob PKCS#7 signature verifier from module signing
      PKCS#7: Check content type and versions
      ASN.1: Add an ASN.1 compiler option to dump the element tree
      ASN.1: Fix handling of CHOICE in ASN.1 compiler
      X.509: Change recorded SKID & AKID to not include Subject or Issuer
      PKCS#7: Support CMS messages also [RFC5652]
      sign-file: Generate CMS message as signature instead of PKCS#7
      X.509: Restrict the usage of a key based on information in X.509 certificate
      X.509: Parse the keyUsage extension to detect key-signing keys
      PKCS#7: Add an optional authenticated attribute to hold firmware name
      KEYS: Restrict signature verification to keys appropriate to the purpose

David Woodhouse (9):
      modsign: Abort modules_install when signing fails
      modsign: Allow password to be specified for signing key
      modsign: Allow signing key to be PKCS#11
      modsign: Allow external signing key to be specified
      modsign: Extract signing cert from CONFIG_MODULE_SIG_KEY if needed
      modsign: Use single PEM file for autogenerated key
      modsign: Add explicit CONFIG_SYSTEM_TRUSTED_KEYS option
      extract-cert: Cope with multiple X.509 certificates in a single file
      modsign: Use extract-cert to process CONFIG_SYSTEM_TRUSTED_KEYS

Luis R. Rodriguez (1):
      sign-file: Add option to only create signature file


 .gitignore                                |    1 
 Documentation/kbuild/kbuild.txt           |    5 
 Documentation/module-signing.txt          |   51 +++-
 Makefile                                  |    8 -
 arch/x86/kernel/kexec-bzimage64.c         |    4 
 crypto/asymmetric_keys/Makefile           |   12 +
 crypto/asymmetric_keys/asymmetric_type.c  |   14 +
 crypto/asymmetric_keys/pkcs7.asn1         |   16 +
 crypto/asymmetric_keys/pkcs7_key_type.c   |   17 +
 crypto/asymmetric_keys/pkcs7_parser.c     |  208 ++++++++++++++
 crypto/asymmetric_keys/pkcs7_parser.h     |    6 
 crypto/asymmetric_keys/pkcs7_trust.c      |   24 +-
 crypto/asymmetric_keys/pkcs7_verify.c     |  101 +++++--
 crypto/asymmetric_keys/public_key.c       |   79 +++++
 crypto/asymmetric_keys/public_key.h       |    3 
 crypto/asymmetric_keys/signature.c        |    6 
 crypto/asymmetric_keys/verify_pefile.c    |    9 -
 crypto/asymmetric_keys/x509_akid.asn1     |   35 ++
 crypto/asymmetric_keys/x509_cert_parser.c |  251 ++++++++++++++---
 crypto/asymmetric_keys/x509_extusage.asn1 |    3 
 crypto/asymmetric_keys/x509_parser.h      |    8 -
 crypto/asymmetric_keys/x509_public_key.c  |  101 +++++--
 include/crypto/pkcs7.h                    |   10 +
 include/crypto/public_key.h               |   36 ++
 include/keys/asymmetric-subtype.h         |    7 
 include/keys/system_keyring.h             |    8 +
 include/linux/oid_registry.h              |    8 +
 include/linux/verify_pefile.h             |    6 
 init/Kconfig                              |   55 +++-
 kernel/Makefile                           |  114 ++++++--
 kernel/module_signing.c                   |  213 +--------------
 kernel/system_certificates.S              |    3 
 kernel/system_keyring.c                   |   78 +++++
 lib/oid_registry.c                        |    1 
 scripts/Makefile                          |    4 
 scripts/Makefile.modinst                  |    2 
 scripts/asn1_compiler.c                   |  104 ++++++-
 scripts/extract-cert.c                    |  166 +++++++++++
 scripts/sign-file                         |  421 -----------------------------
 scripts/sign-file.c                       |  288 ++++++++++++++++++++
 security/integrity/digsig_asymmetric.c    |    3 
 41 files changed, 1647 insertions(+), 842 deletions(-)
 create mode 100644 crypto/asymmetric_keys/x509_akid.asn1
 create mode 100644 crypto/asymmetric_keys/x509_extusage.asn1
 create mode 100644 scripts/extract-cert.c
 delete mode 100755 scripts/sign-file
 create mode 100755 scripts/sign-file.c

