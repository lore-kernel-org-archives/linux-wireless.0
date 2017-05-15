Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757106AbdEOJdl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 05:33:41 -0400
Date: Mon, 15 May 2017 11:33:00 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlegacy: warn when enabling power save
Message-ID: <20170515093259.GA16559@redhat.com> (sfid-20170515_113348_044346_155CCAFA)
References: <1494835148-12945-1-git-send-email-sgruszka@redhat.com>
 <87ziee5x7i.fsf@purkki.adurom.net>
 <20170515092037.GA9899@redhat.com>
 <e12d8965-d97b-f5b6-381c-0eaebee86983@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e12d8965-d97b-f5b6-381c-0eaebee86983@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 15, 2017 at 11:25:51AM +0200, Arend van Spriel wrote:
> On 5/15/2017 11:20 AM, Stanislaw Gruszka wrote:
> >On Mon, May 15, 2017 at 11:41:05AM +0300, Kalle Valo wrote:
> >>Stanislaw Gruszka <sgruszka@redhat.com> writes:
> >>
> >>>iwlegacy firmware can crash when power save is configured. PS was
> >>>allowed in "dbdac2b iwlegacy: properly enable power saving" with belive
> >>>that user who enable PS is aware of that and can relate firmware crahes
> >>>with PS. However some distributions seems to enable PS without user
> >>>intervention, so warn about that.
> >>>
> >>>Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >>>---
> >>>  drivers/net/wireless/intel/iwlegacy/common.c |    2 ++
> >>>  1 files changed, 2 insertions(+), 0 deletions(-)
> >>>
> >>>diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
> >>>index 140b6ea..6aaa0e7 100644
> >>>--- a/drivers/net/wireless/intel/iwlegacy/common.c
> >>>+++ b/drivers/net/wireless/intel/iwlegacy/common.c
> >>>@@ -5147,6 +5147,8 @@ void il_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> >>>  	if (changed & (IEEE80211_CONF_CHANGE_PS | IEEE80211_CONF_CHANGE_IDLE)) {
> >>>  		il->power_data.ps_disabled = !(conf->flags & IEEE80211_CONF_PS);
> >>>+		WARN_ONCE(!il->power_data.ps_disabled,
> >>>+			  "Enabling power save might cause firmware crashes\n");
> >>
> >>This prints the whole stack trace, right? Isn't that excessive and
> >>fooling the users to think that they found a bug, which would mean more
> >>bug reports sent to us? So maybe a simple printk is better here?
> >
> >I wanted to have back trace to assure problem will not be missed, but
> >I think you have right, I'll post v2.
> 
> I think instead of printk, a wiphy_warn() would be better here using
> hw->wiphy.

I used dev_warn variant, what is consistent with the driver code.

Stanislaw
