Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57423 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LCQGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 11:06:01 -0500
Received: by mail-pd0-f182.google.com with SMTP id v10so20446882pde.27
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 08:06:01 -0800 (PST)
Message-ID: <529E0166.90302@lwfinger.net> (sfid-20131203_170606_947064_E95AFB9D)
Date: Tue, 03 Dec 2013 10:05:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Nikita N." <nikitan@operamail.com>, linux-wireless@vger.kernel.org
Subject: Re: RTL8187 bugs
References: <1385589961.19021.52907237.3EE33E5B@webmail.messagingengine.com> <52966D64.2030805@lwfinger.net> <1385593188.3627.52911717.4E0712D9@webmail.messagingengine.com> <52968893.6060405@lwfinger.net> <1385812990.14905.53777877.7646278B@webmail.messagingengine.com> <529A1B52.6040605@lwfinger.net> <1385835820.6559.53858669.5FD3F3A6@webmail.messagingengine.com> <529A36C5.4060209@lwfinger.net> <1386079140.19919.54929613.506DE0D0@webmail.messagingengine.com>
In-Reply-To: <1386079140.19919.54929613.506DE0D0@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/03/2013 07:59 AM, Nikita N. wrote:
> Hi Larry :) Im afraid I didnt receive your answer to my last email.. in
> case you sent, please resend, thanks :)
>
> As for "dissecting" the issue, as you suggested, I have been filling
> your code with debug lines.
> Very interesting in my opinion is the report from
> drivers/net/wireless/rtl818x/rtl8187/dev.c#rtl8187_configure_filter(),
> as follows:
>
> IN>changed_flags=240,total_flags=2147483888,multicast=0,priv->rx_conf=2425682954
>> FIF_CONTROL
>> FIF_OTHER_BSS
>> not FIF_ALLMULTI
> drivers/net/wireless/rtl818x/rtl8187/dev.c#rtl818x_iowrite32_async
> drivers/net/wireless/rtl818x/rtl8187/dev.c#rtl8187_iowrite_async
> OUT>total_flags=96,priv->rx_conf=2426207243

Please do not dump pointers, flags, etc. as a decimal value. In most cases, you 
need to hexadecimal value to interpret them. Why not output them in hex to begin 
with?

> .. after, some daemon calls it again multiple times, but result is
> always the same as follows:
> IN>changed_flags=144,total_flags=2147483888,multicast=0,priv->rx_conf=2426207243
>> not FIF_ALLMULTI
> drivers/net/wireless/rtl818x/rtl8187/dev.c#rtl818x_iowrite32_async
> drivers/net/wireless/rtl818x/rtl8187/dev.c#rtl8187_iowrite_async
> net/mac80211/util.c#ieee80211_queue_work
> OUT>total_flags=96,priv->rx_conf=2426207243
>
> .. seeing anything unusual?
>
> I have the strange feeling that "IN" value of priv->rx_conf could be
> bugged.. as result the relative OUT value is maybe wrong.. :P
>
> Anyway, could you please perform the same test on your working
> interfaces, and report me the output?
> The values of IN/OUT and so on, of rtl8187_configure_filter(), *AFTER*
> calling "airmon-ng start wlan0"?

If you want me to test anything, you need to send me patches that I can apply. 
Having to regenerate your patches here is something I have no interest in doing.

>>From your probe, my interface type is as follow:
> - "RTL8187vB (default)"
> - PCI_EEPROM_WIDTH_93C46
> - customer id 0
>
> Please insert the following debug lines, as I did:
> static void rtl8187_configure_filter()
> {
> printk(KERN_WARNING
> "drivers/net/wireless/rtl818x/rtl8187/dev.c#rtl8187_configure_filter");
> 	struct rtl8187_priv *priv = dev->priv;
> printk(KERN_WARNING
> "IN>changed_flags=%u,total_flags=%u,multicast=%llu,priv->rx_conf=%u",changed_flags,*total_flags,multicast,priv->rx_conf);
> 	if (changed_flags & FIF_FCSFAIL) {
> 		priv->rx_conf ^= RTL818X_RX_CONF_FCS;
> printk(KERN_WARNING ">FIF_FCSFAIL");}
> 	if (changed_flags & FIF_CONTROL) {
> 		priv->rx_conf ^= RTL818X_RX_CONF_CTRL;
> printk(KERN_WARNING ">FIF_CONTROL");}
> 	if (changed_flags & FIF_OTHER_BSS) {
> 		priv->rx_conf ^= RTL818X_RX_CONF_MONITOR;
> printk(KERN_WARNING ">FIF_OTHER_BSS");}
> 	if (*total_flags & FIF_ALLMULTI || multicast > 0) {
> 		priv->rx_conf |= RTL818X_RX_CONF_MULTICAST;
> printk(KERN_WARNING ">FIF_ALLMULTI");}
> else {
> 		priv->rx_conf &= ~RTL818X_RX_CONF_MULTICAST;
> printk(KERN_WARNING ">not FIF_ALLMULTI");}
>
> 	rtl818x_iowrite32_async(priv, &priv->map->RX_CONF,
> 	priv->rx_conf);
> printk(KERN_WARNING
> "OUT>total_flags=%u,priv->rx_conf=%u",*total_flags,priv->rx_conf);
> }
>
> If you get different outputs also between your interfaces, please send
> me all different outputs!
> thanks :)

Larry


