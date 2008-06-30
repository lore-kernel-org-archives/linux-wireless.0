Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:10629 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbYF3K2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 06:28:54 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1485985wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 03:28:53 -0700 (PDT)
Message-ID: <69e28c910806300328v34c0d1efk55792256c49c39f9@mail.gmail.com> (sfid-20080630_122857_270702_3B82AB88)
Date: Mon, 30 Jun 2008 12:28:53 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 29/33] iwlwifi: drop skb silently for Tx request in monitor mode
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <200806301226.50085.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-30-git-send-email-yi.zhu@intel.com>
	 <69e28c910806300322i5ac6e123h23ed5c0419d087c1@mail.gmail.com>
	 <200806301226.50085.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 12:26 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Monday 30 June 2008 12:22:45 Stefanik G=E1bor wrote:
>> On Mon, Jun 30, 2008 at 11:23 AM, Zhu Yi <yi.zhu@intel.com> wrote:
>> > This patch fixes the problem to keep mac80211 resubmitting SKBs
>> > when Tx request cannot be met in monitor mode.
>> >
>> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
>> > ---
>> >  drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
>> >  drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ++-
>> >  2 files changed, 4 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers=
/net/wireless/iwlwifi/iwl3945-base.c
>> > index 4f0a18a..2744b0a 100644
>> > --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
>> > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>> > @@ -6695,7 +6695,8 @@ static int iwl3945_mac_tx(struct ieee80211_h=
w *hw, struct sk_buff *skb)
>> >
>> >        if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
>> >                IWL_DEBUG_MAC80211("leave - monitor\n");
>> > -               return -1;
>> > +               dev_kfree_skb_any(skb);
>> > +               return 0;
>> >        }
>> >
>> >        IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->l=
en,
>> > diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers=
/net/wireless/iwlwifi/iwl4965-base.c
>> > index ba0f289..60b7a64 100644
>> > --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
>> > +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
>> > @@ -2682,7 +2682,8 @@ static int iwl4965_mac_tx(struct ieee80211_h=
w *hw, struct sk_buff *skb)
>> >
>> >        if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
>> >                IWL_DEBUG_MAC80211("leave - monitor\n");
>> > -               return -1;
>> > +               dev_kfree_skb_any(skb);
>> > +               return 0;
>> >        }
>> >
>> >        IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->l=
en,
>> > --
>> > 1.5.3.6
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-wi=
reless" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>> NACK.
>>
>> This blocks packet injection for not only 4965/5000, but also 3945.
>> Also, I have multiple records of injection working with 4965 cards
>> with your original patch.
>>
>
> This patch fixes a _real_ bug. No matter what your plans for packet i=
njection
> are, it _needs_ to go in for now. You can later change the code to ac=
tually
> transmit the frame. There are only two possibilities for the TX handl=
er:
> Either transmit it or drop it. It must not return an error.
>
>
> --
> Greetings Michael.
>

There is another patch in this same patchset, which completely removes
the anti-injection code from 3945, so this actually causes a merge
conflict. That's why I NACKed.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
