Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42711 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbcCXMBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 08:01:49 -0400
Date: Thu, 24 Mar 2016 17:31:17 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: Add support for ath10k_sta_statistics
 support
Message-ID: <20160324120117.GA30872@atheros-ThinkPad-T61> (sfid-20160324_130153_782208_3C01FD6F)
References: <1458211740-6875-1-git-send-email-mohammed@qca.qualcomm.com>
 <CA+BoTQkk30nPEKiP-8FA2DcddJ_SL90txgHQeua7GCauR_M2dg@mail.gmail.com>
 <20160317112022.GA27512@atheros-ThinkPad-T61>
 <CA+BoTQ=DG=oixf2LtVbxvRL6WvnQDcyOHP=ayHbmNAsQrTPMvA@mail.gmail.com>
 <20160317122956.GA30285@atheros-ThinkPad-T61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160317122956.GA30285@atheros-ThinkPad-T61>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal / Kalle,

> 
> On Thu, Mar 17, 2016 at 12:35:00PM +0100, Michal Kazior wrote:
> > On 17 March 2016 at 12:20, Mohammed Shafi Shajakhan
> > <mohammed@codeaurora.org> wrote:
> > > Hi Michal,
> > >
> > > On Thu, Mar 17, 2016 at 12:12:31PM +0100, Michal Kazior wrote:
> > >> On 17 March 2016 at 11:48, Mohammed Shafi Shajakhan
> > >> <mohammed@qti.qualcomm.com> wrote:
> > >> [...]
> > >> > +void ath10k_sta_statistics(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> > >> > +                          struct ieee80211_sta *sta,
> > >> > +                          struct station_info *sinfo)
> > >> > +{
> > >> > +       struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
> > >> > +       struct ath10k *ar = arsta->arvif->ar;
> > >> > +
> > >> > +       mutex_lock(&ar->conf_mutex);
> > >> > +
> > >> > +       if (ar->state != ATH10K_STATE_ON &&
> > >> > +           ar->state != ATH10K_STATE_RESTARTED)
> > >> > +               goto out;
> > >>
> > >> Do you really need mutex and ar->state check in this function?
> > >>
> > >
> > > [shafi] By default peer stats will be disabled, we are enabling this by debugfs
> > > (hw-restart) so i thought these checks are needed , please advise .. Do you say
> > > they  will be never hit
> > 
> > Hmm.. I think mac80211 shouldn't call sta_statistics() before
> > sta_state() during recovery (it makes no sense). In practice I think
> > this isn't enforced in which case it's a mac80211 bug.
> 
> [shafi] sure i will check this. If the hardware is restarting there should
> be no stations connected and station related info.

[shafi] I did not see any checks in mac80211 to prevent this (may be i missed
something), but i did remove the checks and tested it, could not find warnings, crashes
(or) garbage values, so is it safer to remove (unless we find some issue with
this) ?, please suggest Michal.

i was doing this parallely in two terminals

a) while true
do
cat rx_stats | grep duration -A 2
done

b) /sys/kernel/debug/ieee80211/phy0/ath10k# echo 1 > peer_stats 
 /sys/kernel/debug/ieee80211/phy0/ath10k# echo 0 > peer_stats 

 (or)
 /sys/kernel/debug/ieee80211/phy0/ath10k# echo hw-restart > simulate_fw_crash 



> 
> > 
> > Anyway, this isn't much of a problem now. You only read out u64 from
> > `arsta` (sta->drv_priv). Even if it's uninitialized/undefined there's
> > no way for you to crash the system (it's not a list, spinlock or any
> > other complex data structure). Worst case userspace will get garbage
> > rx_duration value if it happens to get_station() while hw-restart is
> > ongoing.
> 
> [shafi] will check this ..

[shafi] agree though i could not see any checks in mac80211 to prevent
sta_set_sinfo (or check for the station state), i did not see any issues in my
testing

> 
> > 
> > It'd be good to verify this is actually a problem and - assuming you
> > want to guarantee correct readouts at all times - to fix the problem
> > in mac80211.
> >
> [shafi] ok, sure

[shafi] I really don't have a deeper understanding of mac80211 code,
i need to go through it thoroughly if i need to have checks for this
if they were not already there.

regards,
shafi
