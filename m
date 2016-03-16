Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34542 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934717AbcCPX0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 19:26:34 -0400
MIME-Version: 1.0
In-Reply-To: <f65e448bfd344867afbf6c002cdfc2bf@SC-EXCH04.marvell.com>
References: <1448618297-19803-1-git-send-email-akarwar@marvell.com>
 <87vb855qpe.fsf@kamboji.qca.qualcomm.com> <f65e448bfd344867afbf6c002cdfc2bf@SC-EXCH04.marvell.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 17 Mar 2016 10:26:01 +1100
Message-ID: <CAGRGNgWvt7OUaiyfK2a17cfTCx=N4tPkeojhvahxOfvK3aBKRQ@mail.gmail.com> (sfid-20160317_002637_680122_A8ED0081)
Subject: Re: [PATCH] mwifiex: parse hscfg_gpio info from device tree
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amitkumar,

On Fri, Dec 11, 2015 at 8:23 PM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Kalle,
>
>> -----Original Message-----
>> From: Kalle Valo [mailto:kvalo@codeaurora.org]
>> Sent: Friday, December 11, 2015 2:04 PM
>> To: Amitkumar Karwar
>> Cc: linux-wireless@vger.kernel.org; Nishant Sarmukadam; Xinming Hu;
>> devicetree@vger.kernel.org
>> Subject: Re: [PATCH] mwifiex: parse hscfg_gpio info from device tree
>>
>> + devicetree list
>>
>> Amitkumar Karwar <akarwar@marvell.com> writes:
>>
>> > From: Xinming Hu <huxm@marvell.com>
>> >
>> > This patch reads hscfg_gpio from device tree and update internal
>> > variable
>> >
>> > Signed-off-by: Xinming Hu <huxm@marvell.com>
>> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
>> > ---
>> >  drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 11 +++++++++++
>> >  1 file changed, 11 insertions(+)
>> >
>> > diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
>> > b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
>> > index e486867..d28a53f 100644
>> > --- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
>> > +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
>> > @@ -1459,10 +1459,21 @@ int mwifiex_dnld_dt_cfgdata(struct
>> > mwifiex_private *priv,  #ifdef CONFIG_OF
>> >     struct property *prop;
>> >     size_t len = strlen(prefix);
>> > +   u32 data;
>> >     int ret;
>> >
>> >     /* look for all matching property names */
>> >     for_each_property_of_node(node, prop) {
>> > +           if (!strncmp(prop->name, "marvell,hscfg_gpio",
>> > +                        strlen("marvell,hscfg_gpio"))) {
>> > +                   if (!of_property_read_u32(priv->adapter->dt_node,
>> > +                                             prop->name, &data)) {
>> > +                           dev_dbg(priv->adapter->dev,
>> > +                                   "hscfg gpio = 0x%x\n", data);
>> > +                           priv->adapter->hs_cfg.gpio = data;
>> > +                   }
>> > +           }
>>
>> I don't see this documented in Documentation/devicetree/bindings. Please
>> create a binding document and review it with the device tree
>> maintainers.
>>
>> Actually when looking mwifiex close I see that it uses more undocumented
>> device tree interfaces:
>>
>> marvell_cfgdata
>> marvell,caldata
>> marvell,00_txpwrlimit
>>
>> I think these all should be properly documented and reviewed. But I'll
>> let the device tree people chime in what's the best way.
>>
>
> Thanks for the review.
> Sure. We will document existing DT interfaces and create updated version of this patch which includes documentation in bindings.

It's been a while since this was reviewed. Do you have an updated
version of this patch?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
