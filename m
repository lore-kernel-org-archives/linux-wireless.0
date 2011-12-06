Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44297 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1LFUPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 15:15:17 -0500
Date: Tue, 6 Dec 2011 15:03:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Philipp Dreimann <philipp@dreimann.net>,
	linux-wireless@vger.kernel.org,
	"'Chaoming_Li'" <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH] rtl8192{ce,cu,de,se}: avoid problems because of possible
 ERFOFF -> ERFSLEEP -> .. transition
Message-ID: <20111206200324.GD30288@tuxdriver.com> (sfid-20111206_211521_701416_C2E1FC2B)
References: <1322526100-6433-1-git-send-email-philipp@dreimann.net>
 <4ED42A75.4010605@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4ED42A75.4010605@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Still waiting to see Chaoming's answer...  Also, the patch needs
to be posted with a Signed-off-by and without greetings or other
non-pertinent stuff in the changelog.

John

On Mon, Nov 28, 2011 at 06:42:29PM -0600, Larry Finger wrote:
> On 11/28/2011 06:21 PM, Philipp Dreimann wrote:
> >Hello!
> >
> >I noticed that ppsc->rfpwr_state could be set to ERFSLEEP even
> >though the device is actually in ERFOFF.
> >
> >Or am I missing something?
> >
> >BR,
> >  Philipp
> >
> >---
> >  drivers/net/wireless/rtlwifi/rtl8192ce/phy.c |    3 ++-
> >  drivers/net/wireless/rtlwifi/rtl8192cu/phy.c |    3 ++-
> >  drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    2 +-
> >  drivers/net/wireless/rtlwifi/rtl8192se/phy.c |    3 ++-
> >  4 files changed, 7 insertions(+), 4 deletions(-)
> >
> >diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
> >index 592a10a..7f6b933 100644
> >--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
> >+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
> >@@ -569,7 +569,8 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
> >  		}
> >  	case ERFSLEEP:{
> >  			if (ppsc->rfpwr_state == ERFOFF)
> >-				break;
> >+				return false;
> >+				
> >  			for (queue_id = 0, i = 0;
> >  			     queue_id<  RTL_PCI_MAX_TX_QUEUE_COUNT;) {
> >  				ring =&pcipriv->dev.tx_ring[queue_id];
> >diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
> >index 7285290..33ada66 100644
> >--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
> >+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
> >@@ -548,7 +548,8 @@ static bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
> >  		break;
> >  	case ERFSLEEP:
> >  		if (ppsc->rfpwr_state == ERFOFF)
> >-			break;
> >+			return false;
> >+			
> >  		for (queue_id = 0, i = 0;
> >  		     queue_id<  RTL_PCI_MAX_TX_QUEUE_COUNT;) {
> >  			ring =&pcipriv->dev.tx_ring[queue_id];
> >diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> >index 3ac7af1..0883349 100644
> >--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> >+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> >@@ -3374,7 +3374,7 @@ bool rtl92d_phy_set_rf_power_state(struct ieee80211_hw *hw,
> >  		break;
> >  	case ERFSLEEP:
> >  		if (ppsc->rfpwr_state == ERFOFF)
> >-			break;
> >+			return false;
> >
> >  		for (queue_id = 0, i = 0;
> >  		     queue_id<  RTL_PCI_MAX_TX_QUEUE_COUNT;) {
> >diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
> >index f27171a..539172e 100644
> >--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
> >+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
> >@@ -602,7 +602,8 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
> >  		}
> >  	case ERFSLEEP:
> >  			if (ppsc->rfpwr_state == ERFOFF)
> >-				break;
> >+				return false;
> >+				
> >
> >  			for (queue_id = 0, i = 0;
> >  			     queue_id<  RTL_PCI_MAX_TX_QUEUE_COUNT;) {
> 
> Yes, it would be possible to jump from ERFSLEEP to ERFOFF in the code.
> 
> Chaoming: Is this what you want, or is it a bug?
> 
> Thanks,
> 
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
