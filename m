Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55403 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752180AbdFOSZY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:24 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 00/23] neard: Support TI Std & Pro tags, fixups, etc.
Date: Thu, 15 Jun 2017 11:24:53 -0700
Message-Id: <20170615182516.4508-1-mgreer@animalcreek.com> (sfid-20170615_202536_684458_629D5118)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an assortment of commits that make some fixups, do some general
tightening of NDEF data checking, add support for TI Standard and Pro
Type 5 tags, and stop issuing the Read Multiple Blocks command when
formatting a Type 5 tag.  The reasoning for each change is in the
individual commit descriptions.

For convenience, a branch with these commits is available in the
submit/updates-v1 branch here:

	https://github.com/animalcreek/neard.git

Mark Greer (23):
  ndef: Add default language ("en") for Text records
  ndef: Fix use of uninitialized variable in property_get_type()
  ndef: Unrecognized WKTs should return RECORD_TYPE_UNKNOWN
  ndef: Verify RTD record type name encodings
  ndef: Discard records containing errors
  ndef: Validate text data in WKT Text records
  adapter: Return '-errno' when socket() call fails
  adapter: Return '-errno' when connect() call fails
  adapter: Clear timeout handle when check presence timer stopped
  adapter: Clear timer handle when DEP timer stopped
  adapter: Do not poll when there is an active tag
  nfctype2: Don't read tags with bad magic number
  nfctype5: Reduce noise when tag is moved out of range
  nfctype5: Add space between 'if' and first '('
  nfctype5: Remove superfluous parentheses
  nfctype5: Rework code that identifies ST Micro Type 5 tags
  nfctype5: Add support for TI Standard and Pro Type 5 tag
  nfctype5: Remove useless initialization
  nfctype5: Don't issue RMB command when formatting
  nfctype5: Discard extra byte in RMB response data
  nfctype5: Fix formatting
  nfctools: Move nciattach macros & enums to nciattach.c
  nfc_copy: Update nfc_copy.h to match Linux kernel's version

 include/nfc_copy.h          |  63 +++++----
 plugins/nfctype2.c          |   1 +
 plugins/nfctype5.c          | 320 ++++++++++++++++++++++++--------------------
 src/adapter.c               |  15 ++-
 src/ndef.c                  |  43 +++++-
 tools/nciattach.c           |  12 ++
 tools/nfctool/llcp-decode.c |  14 +-
 tools/nfctool/snep-decode.c |  12 +-
 8 files changed, 290 insertions(+), 190 deletions(-)

-- 
2.13.0
