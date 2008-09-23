Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:31354 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYIWSZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 14:25:38 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2288040rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2008 11:25:37 -0700 (PDT)
Message-ID: <45e8e6c40809231125u4ef40f5brcd1694ee19e8b73@mail.gmail.com> (sfid-20080923_202540_804614_DA4B2E60)
Date: Tue, 23 Sep 2008 11:25:37 -0700
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "David Shwatrz" <dshwatrz@gmail.com>
Subject: Re: A question about setting Master mode and ieee80211_ioctl_siwmode() handler
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <31436f4a0809220625s240a786cl7602dcb35f7039a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <31436f4a0809220625s240a786cl7602dcb35f7039a5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Master mode is deliberately disabled at this time.  You can enable it
by applying:
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/004-allow-ap-vlan-modes.patch

On Mon, Sep 22, 2008 at 6:25 AM, David Shwatrz <dshwatrz@gmail.com> wrote:
> Hello,
> I have a short question:
>  I wonder how can a command like :
> "iwconfig wlan0 mode Master"
> should succeed ;
> I did tried it on some wireless NIC, which probably does not support
> master mode, and got:
> "Error for wireless request "Set Mode" (8B06) :
>    SET failed on device wlan0 ; Invalid argument."
>
>
> The reason is this:
> I look at the kernel code which implements receiving the set mode IOCTL.
>
> The method is ieee80211_ioctl_siwmode(), in net/mac80211/wext.c.
>
> (I am looking at the last git wireless tree; it appears here below).
>
> As far as I can see, we don't handle the "Master" mode in the case
> sentence , so when we try to set the mode to Master,
> by :
> "iwconfig wlan0 mode Master"
> we will always get to the default and exit with
>                "return -EINVAL"
>
> Am I wrong here ? can somebody please explain?
>
> static int ieee80211_ioctl_siwmode(struct net_device *dev,
>                                   struct iw_request_info *info,
>                                   __u32 *mode, char *extra)
> {
>        struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>        int type;
>
>        if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
>                return -EOPNOTSUPP;
>
>        switch (*mode) {
>        case IW_MODE_INFRA:
>                type = IEEE80211_IF_TYPE_STA;
>                break;
>        case IW_MODE_ADHOC:
>                type = IEEE80211_IF_TYPE_IBSS;
>                break;
>        case IW_MODE_REPEAT:
>                type = IEEE80211_IF_TYPE_WDS;
>                break;
>        case IW_MODE_MONITOR:
>                type = IEEE80211_IF_TYPE_MNTR;
>                break;
>        default:
>                return -EINVAL;
>        }
>
>        return ieee80211_if_change_type(sdata, type);
> }
>
>
> Any ideas?
> Regards,
> DS
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
