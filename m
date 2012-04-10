Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36699 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab2DJTTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 15:19:30 -0400
Message-ID: <4F846257.1060807@sipsolutions.net> (sfid-20120410_211935_933679_108DA878)
Date: Tue, 10 Apr 2012 18:39:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
CC: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120410_141120_556160_FD038CE7)
In-Reply-To: <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120410_141120_556160_FD038CE7)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrei,

> Add new interface type VIRTUAL_AMP80211 which emulates Bluetooth AMP
> Controller. AMP is Alternate MAC/PHYs Controller for Bluetooth sybsystem.
> When an AMP is common between the two devices, the Bluetooth system
> provides mechanisms for moving data traffic from BR/EDR Controller to
> an AMP Controller.

Interesting work. I would have expected to see more work in cfg80211 
though, this is a bit unexpected. How is it controlled at all?

>   create mode 100644 net/mac80211/virtual_amp.c

Also, why is it "virtual"? I would rather you name the file btamp.c or 
such -- to you, AMP may mean something, but to us wifi people it really 
doesn't mean much. I suspect most wouldn't even know where to look for a 
definition of it.

> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -1783,7 +1783,8 @@ static int __init init_mac80211_hwsim(void)
>   			BIT(NL80211_IFTYPE_P2P_CLIENT) |
>   			BIT(NL80211_IFTYPE_P2P_GO) |
>   			BIT(NL80211_IFTYPE_ADHOC) |
> -			BIT(NL80211_IFTYPE_MESH_POINT);
> +			BIT(NL80211_IFTYPE_MESH_POINT) |
> +			BIT(NL80211_IFTYPE_VIRTUAL_AMP80211);

This is insufficient, it should also beacon.

> +++ b/include/linux/nl80211.h
> @@ -1546,6 +1546,7 @@ enum nl80211_iftype {
>   	NL80211_IFTYPE_MESH_POINT,
>   	NL80211_IFTYPE_P2P_CLIENT,
>   	NL80211_IFTYPE_P2P_GO,
> +	NL80211_IFTYPE_VIRTUAL_AMP80211,

I believe that this may need additional checks in cfg80211 so that you 
can't simply add this interface type.

> +config MAC80211_VIRTUAL_AMP
> +	bool "Virtual AMP80211 device"
> +	---help---
> +	  Enable Bluetooth Virtual / Software AMP 80211 controller.
> +	  When AMP is common between two devices data may be routed
> +	  through fast 80211 connection from standard Bluetooth BR/EDR

802.11, and the whole virtual vs. Bluetooth thing again.

Also, it seems this really needs a dependency on BT.

> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index d9798a3..0e39ed7 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -709,6 +709,10 @@ struct ieee80211_sub_if_data {
>   	u32 rc_rateidx_mask[IEEE80211_NUM_BANDS];
>   	u8  rc_rateidx_mcs_mask[IEEE80211_NUM_BANDS][IEEE80211_HT_MCS_MASK_LEN];
>
> +#ifdef CONFIG_MAC80211_VIRTUAL_AMP
> +	struct hci_dev *hdev;
> +#endif

That should be inside the union:

>   	union {
>   		struct ieee80211_if_ap ap;
>   		struct ieee80211_if_wds wds;

> @@ -898,6 +900,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
>   	case NL80211_IFTYPE_WDS:
>   	case NL80211_IFTYPE_AP_VLAN:
>   		break;
> +	case NL80211_IFTYPE_VIRTUAL_AMP80211:
> +#ifdef CONFIG_MAC80211_VIRTUAL_AMP
> +		ieee80211_vamp_setup_sdata(sdata);

I also really don't like the abbrevation "vamp". It means even less than 
"virtual AMP", particularly for people not familiar with BT terminology. 
Please also use btamp or so.

> +static void ieee80211_clean_sdata(struct ieee80211_sub_if_data *sdata)
> +{
> +	switch (sdata->vif.type) {
> +	case NL80211_IFTYPE_VIRTUAL_AMP80211:
> +#ifdef CONFIG_MAC80211_VIRTUAL_AMP
> +		ieee80211_vamp_clean_sdata(sdata);
> +#endif

That's really bad form. Please hide the ifdefs better, or use an if 
construct with something like vif_is_mesh() below that will not need ifdefs:

> @@ -1230,6 +1250,9 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
>   	if (ieee80211_vif_is_mesh(&sdata->vif))
>   		mesh_path_flush_by_iface(sdata);
>
> +	/* clean up type-dependent data */
> +	ieee80211_clean_sdata(sdata);

Seems you should move the mesh pieces into the new function ... Possibly 
as a previous refactor patch.

> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1299,6 +1299,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>   		case NUM_NL80211_IFTYPES:
>   		case NL80211_IFTYPE_P2P_CLIENT:
>   		case NL80211_IFTYPE_P2P_GO:
> +		case NL80211_IFTYPE_VIRTUAL_AMP80211:
>   			WARN_ON(1);

Umm. This can happen, I'd say.

> +#include<net/bluetooth/bluetooth.h>

I'm not sure I fully trust thunderbird, but there seem to be missing spaces.

> +static int virtual_amp_init(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct hci_dev *hdev;
> +	struct vamp_data *data;
> +
> +	data = kzalloc(sizeof(struct vamp_data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;

Why can't you embed the data in the union inside the sdata? it's 
probably smaller than managed anyway.

> +	hdev->bus = HCI_VIRTUAL;

Should that really be that way?

> +	hci_set_drvdata(hdev, data);
> +
> +	hdev->dev_type = HCI_AMP;
> +
> +	hdev->open     = vamp_open_dev;
> +	hdev->close    = vamp_close_dev;
> +	hdev->flush    = vamp_flush;
> +	hdev->send     = vamp_send_frame;
> +
> +	if (hci_register_dev(hdev)<  0) {
> +		BT_ERR("Can't register HCI device");
> +		kfree(data);
> +		hci_free_dev(hdev);
> +		return -EBUSY;
> +	}

Why go have return values when you don't use them:

> +void ieee80211_vamp_setup_sdata(struct ieee80211_sub_if_data *sdata)
> +{
> +	pr_info("Create virtual AMP device");
> +
> +	virtual_amp_init(sdata);
> +
> +}

Anyway.

I don't get this patch at all. Why am I reviewing some very very basic 
skeleton code when we should be discussing userspace APIs (we have 
already discussed them with a few people years ago), how the AMP is 
going to be managed, how the security handshake is going to work, etc.

johannes
