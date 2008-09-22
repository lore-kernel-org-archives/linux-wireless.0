Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:51573 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbYIVNZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 09:25:36 -0400
Received: by yx-out-2324.google.com with SMTP id 8so219472yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 06:25:35 -0700 (PDT)
Message-ID: <31436f4a0809220625s240a786cl7602dcb35f7039a5@mail.gmail.com> (sfid-20080922_152540_976377_245B9C56)
Date: Mon, 22 Sep 2008 16:25:34 +0300
From: "David Shwatrz" <dshwatrz@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: A question about setting Master mode and ieee80211_ioctl_siwmode() handler
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I have a short question:
  I wonder how can a command like :
"iwconfig wlan0 mode Master"
should succeed ;
I did tried it on some wireless NIC, which probably does not support
master mode, and got:
"Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Invalid argument."


The reason is this:
I look at the kernel code which implements receiving the set mode IOCTL.

The method is ieee80211_ioctl_siwmode(), in net/mac80211/wext.c.

(I am looking at the last git wireless tree; it appears here below).

As far as I can see, we don't handle the "Master" mode in the case
sentence , so when we try to set the mode to Master,
by :
"iwconfig wlan0 mode Master"
we will always get to the default and exit with
		"return -EINVAL"

Am I wrong here ? can somebody please explain?

static int ieee80211_ioctl_siwmode(struct net_device *dev,
				   struct iw_request_info *info,
				   __u32 *mode, char *extra)
{
	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
	int type;

	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
		return -EOPNOTSUPP;

	switch (*mode) {
	case IW_MODE_INFRA:
		type = IEEE80211_IF_TYPE_STA;
		break;
	case IW_MODE_ADHOC:
		type = IEEE80211_IF_TYPE_IBSS;
		break;
	case IW_MODE_REPEAT:
		type = IEEE80211_IF_TYPE_WDS;
		break;
	case IW_MODE_MONITOR:
		type = IEEE80211_IF_TYPE_MNTR;
		break;
	default:
		return -EINVAL;
	}

	return ieee80211_if_change_type(sdata, type);
}


Any ideas?
Regards,
DS
