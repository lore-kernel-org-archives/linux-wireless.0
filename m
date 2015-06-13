Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:60730 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbbFMKkC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 06:40:02 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	Joe Perches <joe@perches.com>,
	Daniele Alessandrelli <daniele.alessandrelli@gmail.com>,
	Aleh Suprunovich <br@ahlamon.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [BUG ?] staging: rtl8723au: condition with no effect
Date: Sat, 13 Jun 2015 12:31:37 +0200
Message-Id: <1434191497-5611-1-git-send-email-hofrat@osadl.org> (sfid-20150613_124020_370298_53E8FA21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

scanning for trivial bug-patters with coccinelle spatches returned:
./drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c:1395
	WARNING: condition with no effect (if branch == else)

drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c - line numbers from 4.1-rc7
1395    if (bWithoutHWSM) {
1396            /* value16 |= (APDM_HOST | FSM_HSUS |/PFM_ALDN); */
1397            /*  2010/08/31 According to Filen description, we need to
1398                use HW to shut down 8051 automatically. */
1399            /*  Because suspend operation need the asistance of 8051
1400                to wait for 3ms. */
1401            value16 = APDM_HOST | AFSM_HSUS | PFM_ALDN;
1402    } else {
1403            value16 = APDM_HOST | AFSM_HSUS | PFM_ALDN;
1404    }
1405 
1406    rtl8723au_write16(padapter, REG_APS_FSMCO, value16);    /* 0x4802 */

Not clear what the intent is but this looks like a typo/bug in the assigment
of value16 as the condition here has no effect.

thx!
hofrat
