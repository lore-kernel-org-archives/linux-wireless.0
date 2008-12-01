Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:54750 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYLARnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 12:43:31 -0500
Received: by qyk4 with SMTP id 4so2804266qyk.13
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 09:43:29 -0800 (PST)
Message-ID: <1ba2fa240812010943p4cc1617asbe66d090ee8f4aa0@mail.gmail.com> (sfid-20081201_184334_553717_15DB06A3)
Date: Mon, 1 Dec 2008 19:43:28 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Helmut Schaa" <helmut.schaa@googlemail.com>
Subject: Re: iwlwifi - rfkill only works if the interface is up
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	"reinette chatre" <reinette.chatre@intel.com>
In-Reply-To: <200812011604.05700.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200812011311.17346.helmut.schaa@gmail.com>
	 <1ba2fa240812010508hcb29699m8bd8b3b0ba8574cd@mail.gmail.com>
	 <200812011604.05700.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 1, 2008 at 5:04 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Montag, 1. Dezember 2008 schrieb Tomas Winkler:
>> On Mon, Dec 1, 2008 at 2:11 PM, Helmut Schaa
>> <helmut.schaa@googlemail.com> wrote:
>
> ...
>
>> > diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
>> > index b935e9d..e2f160b 100644
>> > --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
>> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
>> > @@ -1504,8 +1504,11 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
>> >                 * the driver as well won't allow loading if RFKILL is set
>> >                 * therefore no need to restart the driver from this handler
>> >                 */
>> > -               if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status))
>> > +               if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
>> >                        clear_bit(STATUS_RF_KILL_HW, &priv->status);
>> > +                       if (priv->is_open)
>> > +                               queue_work(priv->workqueue, &priv->restart);
>> > +               }
>> >
>> >                handled |= CSR_INT_BIT_RF_KILL;
>> >        }
>>
>> This is strange, this exact code is part of  patch

>> """
>> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> Date:   Sun Jun 22 11:18:52 2008 +0300
>>  iwlwifi: clean up HW RF-kill state machine and restarts
>>  This patch cleans up HW RF-kill state machine.
>> """
>> The two other hunks of this patch are in the current code, this one is
>> not, I've probably messed up something on they way. I will track this
>> down.
>
> Thanks, should I respin the above patch?

Sorry I was wrong about the patch. The correct one is
http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=commitdiff;h=a91ad840c23a70bc0eabe239e178e0d979a6d44e;hp=5ef81ff85d135e83eff581237de41a362cbdb167

It few problems and I've actually I had it rebased over current code
and started to clean it up but then there were series of unexpected
events which brought it to darkness.
One think for sure what need to be removed form the patch is setting
radio_enabled within the driver code Although mac80211 awareness of
rfkill is still not addressed.
Anyhow If you have free afternoon you can pick  up the patch otherwise
somebody from intel will

>
>> > Nevertheless, I'm wondering if the current behaviour (even with the patch above)
>> > makes much sense. I mean, the user space cannot rely on the rfkill state
>> > unless an appropriate interface is up. As the device is able to report the
>> > killswitch state without firmware being loaded the following approach could
>> > be feasible:
>> > - iwl_pci_probe enables the device and enables the interrupts
>> > - iwl_mac_start just loads the firmware
>> > - iwl_mac_stop just releases the firmware but leaves the interrupts enabled
>>
>> In 3495  rfkill interrupt is not available and rfkill state is
>> delivered only when firmware is loaded, therefore this is not
>> possible to bring device down and also expect rfill switch event.
>
> Would it be possible to poll CSR_GP_CNTRL for that information on iwl3945?

Not sure, need to run and check

>
>> There were few threads about this subject.
>
> Searching for these now ...
>
>> In 4965 and 5000 this will work
>
> Would you agree on that behavior?
> Any objections I did not think of yet?

This is definitely the way but it seems that patch is  just it's not enough.

Thanks
Tomas
