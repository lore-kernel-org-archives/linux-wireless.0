Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:41710 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2GLLUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 07:20:21 -0400
Date: Thu, 12 Jul 2012 14:20:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: re: brcmsmac: use container_of instead of cast
Message-ID: <20120712112007.GA12822@elgon.mountain> (sfid-20120712_132024_851527_150D9F64)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch ed1dd81464f5: "brcmsmac: use container_of instead of cast" 
from Jun 30, 2012, leads to the following Smatch warning:
drivers/net/wireless/brcm80211/brcmsmac/aiutils.c:543 ai_detach()
	 warn: can 'sii' even be NULL?

   533  /* may be called with core in reset */
   534  void ai_detach(struct si_pub *sih)
   535  {
   536          struct si_info *sii;
   537  
   538          struct si_pub *si_local = NULL;
   539          memcpy(&si_local, &sih, sizeof(struct si_pub **));
   540  
   541          sii = container_of(sih, struct si_info, pub);
   542  
   543          if (sii == NULL)
   544                  return;
   545  
   546          kfree(sii);
   547  }


Smatch complains because container_of() of does pointer math and the
check for NULL only works when ->pub is first member of the si_info
struct.

Are you sure you want to free sii and not sih?

Also kfree() checks for NULL.

The memcpy() is pointless.

The white space is not right.  There should be a blank line after the
variable declarations.

regards,
dan carpenter
