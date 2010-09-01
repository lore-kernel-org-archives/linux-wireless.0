Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36241 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab0IAP6S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 11:58:18 -0400
Subject: Re: [WTF, maintainers] Re: *PING* iwlagn 2.6.35: "BA scd_flow 0
 does not match txq_id 10" regression
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <AANLkTik0ssMim0-eRS1kWD+CsE_kCS-RjEm_iEbdPy05@mail.gmail.com>
References: <AANLkTim4_HoHwdhGqAZqcGf2oq7boktdZFW4-w5DpdDa@mail.gmail.com>
	 <AANLkTinuYOvwNZAFgq67f4XBL4YQ+b2z4EBMcmvbMYi3@mail.gmail.com>
	 <1281481505.20038.10.camel@wwguy-ubuntu>
	 <AANLkTinDjp500wXXHbiOmom70Wbvs1OL6LXOfTq06A=U@mail.gmail.com>
	 <1282762406.23359.1.camel@wwguy-huron>
	 <AANLkTik0ssMim0-eRS1kWD+CsE_kCS-RjEm_iEbdPy05@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 01 Sep 2010 08:57:43 -0700
Message-Id: <1283356663.22660.27.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-01 at 08:07 -0700, Andrew Lutomirski wrote:
> On Wed, Aug 25, 2010 at 2:53 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> > On Wed, 2010-08-25 at 11:42 -0700, Andrew Lutomirski wrote:
> >> On Tue, Aug 10, 2010 at 7:05 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> >> > Hi Andrew,
> >> >
> >> > On Tue, 2010-08-10 at 14:39 -0700, Andrew Lutomirski wrote:
> >> >> On Mon, Jul 26, 2010 at 4:02 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> >> >> > There's a regression in 2.6.35 where the connection breaks and iwlagn
> >> >> > writes a bunch of:
> >> >> >
> >> >> > iwlagn 0000:03:00.0: BA scd_flow 0 does not match txq_id 10
> >> >> >
> >> >> > This is confirmed [1] and a patch supposedly exists.  Since this
> >> >> > breaks at least two people's wireless and 2.6.35 is about to be
> >> >> > released, can we see the patches?
> >> >> >
> >> >> > Thanks,
> >> >> > Andy
> >> >> >
> >> >> > [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/53552
> >> >> >
> >> >>
> >> >> This regression was reported on July 21 and confirmed, supposedly with
> >> >> a patch available, on July 24 (or maybe July 23).  On July 26 I pinged
> >> >> the list because I'm affected as well.
> >> >>
> >> >> It's now August 10 and both 2.6.35 and 2.5.35.1 have been released and
> >> >> the bug is still there.  WTF happened?  (I admit I haven't actually
> >> >> tested 2.6.35.1 because it's still compiling, but I see nothing to
> >> >> suggest that it's been fixed.)
> >> >>
> >> >
> >> > Sorry for the delay, the problem you report is a real problem in our
> >> > uCode; unfortunately, we still not root cause the real problem yet. The
> >> > patch I provide previous just a hack and still waiting for our internal
> >> > validation team to make sure it did not break the overall behaviors.
> >> >
> >> > I will submit the patch as soon as I got the report back from our test
> >> > team; at the meantime, we are very active work on root cause the real
> >> > problem. Once we have the possible solution, it will be great if you can
> >> > help us to verify it.
> >>
> >> In case this helps, I just captured the bug starting with
> >> iwlagn.debug=1 and with the following patch:
> >>
> >> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> >> b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> >> index 7d614c4..8583c42 100644
> >> --- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> >> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> >> @@ -1300,8 +1300,9 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
> >>         tid = ba_resp->tid;
> >>         agg = &priv->stations[sta_id].tid[tid].agg;
> >>         if (unlikely(agg->txq_id != scd_flow)) {
> >> -               IWL_ERR(priv, "BA scd_flow %d does not match txq_id %d\n",
> >> -                       scd_flow, agg->txq_id);
> >> +               IWL_ERR(priv, "BA scd_flow %d does not match txq_id %d
> >> (sta_id = %d, tid = %d)\n",
> >> +                       scd_flow, agg->txq_id, sta_id, tid);
> >> +               //              iwl_force_reset(priv, IWL_FW_RESET);
> >>                 return;
> >>         }
> >>
> >>
> >> I've attached the dmesg.  Search for 'BA'.
> >>
> > It is an known issue as I mention. we are working on it and sorry for
> > the delay.
> >
> > please take a look at commit 735df29a0641d9d8d65117c48ee460284ffcfc05
> >
> > "Since it is possible happen very often and we do not want to fill the
> > syslog, so don't enable the logging by default"
> 
> IMO that just makes it worse.  Now people's wireless connections will
> break silently and no one will know if it's this bug or a different
> one.  You could ratelimit the error, though.
> 
> I tried rigging the driver to force a firmware reload when this
> triggers but that doesn't seem to work reliably.

Correct, firmware reload will not fix the problem. We already have the
fix but it is in uCode; now we are working on how to release it per
device based.

Wey


> >
> >

