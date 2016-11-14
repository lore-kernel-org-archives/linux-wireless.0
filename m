Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.eu1.fugro.com ([46.34.88.151]:60839 "EHLO
        smtp.eu1.fugro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752154AbcKNNEq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 08:04:46 -0500
From: "Stam, Michel [FINT]" <m.stam@fugro.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Antonio Quartulli" <a@unstable.cc>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Antonio Quartulli" <antonio@open-mesh.com>
Subject: RE: [ath9k-devel] [NOT FOR MERGE] ath9k: work around key cache
        corruption
Date: Mon, 14 Nov 2016 12:50:51 +0000
Message-ID: <4fd6af4b02474a3eb4acfbe421bd6a24@nldataex02.ad.fugro.com> (sfid-20161114_140450_321502_3E4C08F4)
References: <20161018083552.28592-1-a@unstable.cc>
        <87lgxbxl2d.fsf@purkki.adurom.net> <20161026141016.GB26376@prodigo.lan>
        <87bmy65nz8.fsf@kamboji.qca.qualcomm.com>
        <62a2dc74-4a7c-d3d4-4170-4d5759b07ab3@dd-wrt.com>
        (sfid-20161027_165606_267532_E06CA534)
 <1477580802.4534.20.camel@sipsolutions.net>
In-Reply-To: <1477580802.4534.20.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear List,

After 2 weeks of Ferry Huberts and me trying to resolve this issue, this is the result:
The problem can be mitigated by resetting the chip and immediately replumbing the encryption keys. I wrote a patch for this, which unfortunately this seems to suffer from some locking issues, rtnl_lock and sc->mutex being the chief culprits.

Code snippet:
static void ath9k_plumb_key(struct ieee80211_hw *hw,
               struct ieee80211_vif *vif,
               struct ieee80211_sta *sta,
               struct ieee80211_key_conf *keyconf, void *data)
{
   struct ath_common *common = (struct ath_common *)data;
   int ret;

   /* delete and re-install keys which were programmed into the hardware */
   if (vif && test_bit(keyconf->hw_key_idx, common->keymap)) {
       ath_key_delete(common, keyconf);
       keyconf->hw_key_idx = 0;
       ret = ath_key_config(common, vif, sta, keyconf);
       if (ret >= 0)
           keyconf->hw_key_idx = ret;
   }
}

To reset and replumb, taken from ath_reset_internal():
	ath9k_hw_kill_interrupts(sc->sc_ah);
	set_bit(ATH_OP_HW_RESET, &common->op_flags);
	ath9k_ps_wakeup(sc);
	ath_reset_internal(sc, NULL);
	rtnl_lock();
	ieee80211_iter_keys(sc->hw, NULL, ath9k_plumb_key, common);
	rtnl_unlock();
	ath9k_ps_restore(sc);

In any case, the problem is only mitigated. It is not solved, as I see the error appearing still (less frequently though).
Looking at the OpenHAL has not yielded anything working either (there is a reference to KEY_PLUMB_WAR, but it is not a full implementation).

What I understand from previous attempts to tackle this issue is that Qualcomm is aware of the problem, and a workaround exists in at least the proprietary driver. I have tried to contact Qualcomm support about this, since it is not radio card specific, but I have not received any response so far.

I hope a Qualcomm employee reads this and is able to help obtain the information that is necessary to resolve this issue. Until then, I recommend using software encryption (nohwcrypt), or setting a very long rekeying time.

Kind regards,

Michel Stam
-----Original Message-----
From: ath9k-devel-bounces@lists.ath9k.org [mailto:ath9k-devel-bounces@lists.ath9k.org] On Behalf Of Johannes Berg
Sent: Thursday, October 27, 2016 17:07 PM
To: Sebastian Gottschall; Kalle Valo; Antonio Quartulli
Cc: ath9k-devel@lists.ath9k.org; linux-wireless@vger.kernel.org; Antonio Quartulli
Subject: Re: [ath9k-devel] [NOT FOR MERGE] ath9k: work around key cache corruption

On Thu, 2016-10-27 at 09:54 +0200, Sebastian Gottschall wrote:
> all patches have a unclear license since most patches are not comming
> with any licence declaration ;-)

You should read the DCO some time. Maybe you shouldn't be sending
patches if you think so.

johannes
_______________________________________________
ath9k-devel mailing list
ath9k-devel@lists.ath9k.org
https://lists.ath9k.org/mailman/listinfo/ath9k-devel
