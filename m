Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbbESKCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 06:02:54 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1431996325-8840-3-git-send-email-mcgrof@do-not-panic.com>
References: <1431996325-8840-3-git-send-email-mcgrof@do-not-panic.com> <1431996325-8840-1-git-send-email-mcgrof@do-not-panic.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: dhowells@redhat.com, ming.lei@canonical.com, rusty@rustcorp.com.au,
	torvalds@linux-foundation.org, seth.forshee@canonical.com,
	linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
	linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
	jlee@suse.com, tiwai@suse.de, casey@schaufler-ca.com,
	keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [RFC v3 2/2] firmware: add firmware signature checking support
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 19 May 2015 11:02:44 +0100
Message-ID: <9412.1432029764@warthog.procyon.org.uk> (sfid-20150519_120258_702596_B982981E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:

> +The kernel firmware signing facility enables to cryptographically sign
> +firmware files on a system using the same keys used for module signing.
> +Firmware files's signatures consist of PKCS#7 messages of the respective
> +firmware file. A firmware file named foo.bin, would have its respective
> +signature on the filesystem as foo.bin.p7s. When firmware signature
> +checking is enabled (FIRMWARE_SIG) and when one of the above APIs is used
> +against foo.bin, the file foo.bin.p7s will also be looked for. If
> +FIRMWARE_SIG_FORCE is enabled the foo.bin file will only be allowed to
> +be returned to callers of the above APIs if and only if the foo.bin.p7s
> +file is confirmed to be a valid signature of the foo.bin file. If
> +FIRMWARE_SIG_FORCE is not enabled and only FIRMWARE_SIG is enabled the
> +kernel will be permissive and enabled unsigned firmware files, or firmware
> +files with incorrect signatures. If FIRMWARE_SIG is not enabled the
> +signature file is ignored completely.

I'd rework this paragraph somewhat.  How about:

  The kernel firmware signing facility enables firmware files on a system to
  have associated cryptographic signatures that can be used to validate them.
  This uses the same mechanism as is used for module signing.

  Firmware signatures are kept in separate files from the actual firmware data
  to avoid accidental corruption of the firmware and to avoid licensing issues
  from changes.

  A firmware signature file consists of a PKCS#7 message containing one or
  more cryptographic signatures for the respective firmware file.  The
  signature file is named for the firmware file to which it corresponds and
  must be kept in the same directory.  For instance, for the signature file
  for a firmware file named foo.bin would be named foo.bin.p7s.

  When firmware signature checking is enabled (CONFIG_FIRMWARE_SIG) and when
  one of the above APIs is used against foo.bin, the file foo.bin.p7s will
  also be looked for.

  If a signature file is found, the kernel's system keyring will be searched
  for public keys that can be used to verify the signatures held therein.  For
  any signature for which a matching key is found, the kernel will attempt to
  verify the signature with the key.  If verification fails on any signature,
  the firmware load will be rejected (with EKEYREJECTED) - even if other
  signatures match.

  If CONFIG_FIRMWARE_SIG_FORCE is also enabled, then the firmware load will be
  rejected (with ENOKEY) if there is no signature file or none of the
  signatures match any of the keys in the kernel system keyring.  But if at
  least one signature matches, then the load will be allowed to proceed.

  If CONFIG_FIRMWARE_SIG is not enabled the signature file is ignored
  completely.

David
