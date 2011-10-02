Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46999 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1JBHzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 03:55:18 -0400
Received: by iaqq3 with SMTP id q3so3669293iaq.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Oct 2011 00:55:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110930195706.GE2526@tuxdriver.com>
References: <1316970415-23239-1-git-send-email-eliad@wizery.com>
	<1316970415-23239-3-git-send-email-eliad@wizery.com>
	<20110930195706.GE2526@tuxdriver.com>
Date: Sun, 2 Oct 2011 09:55:17 +0200
Message-ID: <CAB3XZEceCVsBPEsUcf7PPHJsoZOfiz5wfh_0k+sORCkggfzWsw@mail.gmail.com> (sfid-20111002_095522_271928_B5D61CAA)
Subject: Re: [PATCH 3/3] mac80211: pass vif param to conf_tx() callback
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 30, 2011 at 10:57 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sun, Sep 25, 2011 at 08:06:55PM +0300, Eliad Peller wrote:
>> tx params should be configured per interface.
>> Add ieee80211_vif param to the conf_tx callback,
>> and update all the drivers that use this callback.
>>
>> The following spatch was used:
>> @rule1@
>> struct ieee80211_ops ops;
>> identifier conf_tx_op;
>> @@
>>       ops.conf_tx = conf_tx_op;
>>
>> @rule2@
>> identifier rule1.conf_tx_op;
>> identifier hw, queue, params;
>> @@
>>       conf_tx_op (
>> -             struct ieee80211_hw *hw,
>> +             struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>>               u16 queue,
>>               const struct ieee80211_tx_queue_params *params) {...}
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>
>  CC [M]  drivers/net/wireless/mwl8k.o
> drivers/net/wireless/mwl8k.c: In function ‘mwl8k_reload_firmware’:
> drivers/net/wireless/mwl8k.c:5466:3: warning: passing argument 2 of ‘mwl8k_conf_tx’ makes pointer from integer without a cast
> drivers/net/wireless/mwl8k.c:4918:12: note: expected ‘struct ieee80211_vif *’ but argument is of type ‘int’
> drivers/net/wireless/mwl8k.c:5466:3: warning: passing argument 3 of ‘mwl8k_conf_tx’ makes integer from pointer without a cast
> drivers/net/wireless/mwl8k.c:4918:12: note: expected ‘u16’ but argument is of type ‘struct ieee80211_tx_queue_params *’
> drivers/net/wireless/mwl8k.c:5466:3: error: too few arguments to function ‘mwl8k_conf_tx’
> drivers/net/wireless/mwl8k.c:4918:12: note: declared here
> make[1]: *** [drivers/net/wireless/mwl8k.o] Error 1
> make: *** [drivers/net/wireless/] Error 2
>
> Feel free to submit a new patch that doesn't introduce warnings or break the build...
>
sorry for the mess.
in fact, i did selected and compile-tested all the drivers, but as my
.config didn't define CONFIG_PCI, i missed some of them...

as Johannes noted, the actual problem was that spatch failed where the
function definition and the function use span over multiple files.

i'll rebase, fix it, and send a new version soon.

Eliad.
