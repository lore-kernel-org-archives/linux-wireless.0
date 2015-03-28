Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:57317 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbbC1MxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 08:53:18 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	joe@perches.com, Larry.Finger@lwfinger.net, mail@beyermatthias.de,
	m.v.b@runbox.com
Subject: [PATCH v4 00/15] checkpatch clean-up of rtl8723au's rtw_security.c
Date: Sat, 28 Mar 2015 08:52:33 -0400
Message-Id: <1427547168-12078-1-git-send-email-m.v.b@runbox.com> (sfid-20150328_135321_914914_3872E177)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These commits address a number of checkpatch.pl warnings and errors
in rtl8723au's rtw_security.c.

Prior to this set of commits, checkpatch.pl reported the following:
	total: 76 errors, 138 warnings, 1621 lines checked

After applying this set of commits, checkpatch.pl reports the following:
	total: 0 errors, 26 warnings, 1624 lines checked
where the only remaining warnings relate to lines longer than 80
characters and quoted strings split across multiple lines.

There are also a number of commits which improve the code in other ways.
For example, the commit titled "Reorganize a few functions to remove
indentation" reworks two functions to make them more readable, whereas
the commit titled "Rework two byte array comparisons" reworks two CRC
verifications for the same reason, and "Use __func__ in trace logs"
avoids hardcoding function names in trace logs to increase
maintainability.

All of the commits have been verified to compile successfully via the
use of the interactive rebase feature of git.

v4: Rebased onto Greg Kroah-Hartman's staging-next tree, on top of
    the following commit
      commit 153fe946412b5da1a8808f79d4f7f4ebfa7586b0
      staging: fbtft: Do not use binary constants

    In addition, fix-up the commit messages to move the patch revision
    notes below the newly added "---" markers where needed.

v3: Rebased onto Greg Kroah-Hartman's staging-next tree, on top of
    the following commit
      5ec293650827122df300581c17ca1d5de03bac3d.
      Staging: dgnc: release the lock before testing for nullity

    Please see the individual commit messages for the changes
    since v2. In summary, the following commits have been updated:
    - that open brace should be on the previous line
    - suspect code indent for conditional statements

    The following commit is new:
    - Use __func__ in trace logs

    Finally, the following commit has been removed:
    - Do not initialize a static to 0

v2: Please see the individual commit messages for the changes
    since v1. In summary, the following commits have been updated:
    - Reformat whitespace to increase readability
    - Fix "before/around/after" whitespace issues
    - Rework two byte array comparisons

M. Vefa Bicakci (15):
  staging: rtl8723au: Reformat whitespace to increase readability
  staging: rtl8723au: Fix "before/around/after" whitespace issues
  staging: rtl8723au: else should follow close brace
  staging: rtl8723au: Fix the indentation of two lines
  staging: rtl8723au: Reorganize a few functions to remove indentation
  staging: rtl8723au: else is not generally useful after a return
  staging: rtl8723au: Remove unneeded curly braces
  staging: rtl8723au: trailing statements should be on next line
  staging: rtl8723au: that open brace should be on the previous line
  staging: rtl8723au: No spaces at the start of a line
  staging: rtl8723au: Adjust whitespace in and around comments
  staging: rtl8723au: suspect code indent for conditional statements
  staging: rtl8723au: Rework two byte array comparisons
  staging: rtl8723au: Use __func__ in trace logs
  staging: rtl8723au: Remove unneeded comments

 drivers/staging/rtl8723au/core/rtw_security.c | 799 +++++++++++++-------------
 1 file changed, 401 insertions(+), 398 deletions(-)

-- 
2.1.4

