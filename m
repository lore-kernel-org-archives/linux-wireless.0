Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab2EGLlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 07:41:22 -0400
Message-ID: <1336390879.4325.18.camel@jlt3.sipsolutions.net> (sfid-20120507_134151_405321_CE269C26)
Subject: Re: [RFCv2 1/6] mac80211: softamp: Adds Bluetooth Software AMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 07 May 2012 13:41:19 +0200
In-Reply-To: <1335273460-12682-2-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120424_151757_538854_521E8B0B)
References: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 <1335273460-12682-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 (sfid-20120424_151757_538854_521E8B0B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-24 at 16:17 +0300, Andrei Emeltchenko wrote:

> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1546,6 +1546,7 @@ enum nl80211_iftype {
>  	NL80211_IFTYPE_MESH_POINT,
>  	NL80211_IFTYPE_P2P_CLIENT,
>  	NL80211_IFTYPE_P2P_GO,
> +	NL80211_IFTYPE_BLUETOOTH_SOFTAMP,

That should probably be a separate patch also updating cfg80211 (and
maybe mac80211) where needed (at least to suppress the warnings you
saw). Also documentation is needed.

> @@ -211,6 +212,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
>  	case NL80211_IFTYPE_STATION:
>  	case NL80211_IFTYPE_MONITOR:
>  	case NL80211_IFTYPE_ADHOC:
> +	case NL80211_IFTYPE_BLUETOOTH_SOFTAMP:
>  		/* no special treatment */
>  		break;

You should never be able to come here with this interface type -- maybe
make it a warning or something.

> +static int vamp_send_frame(struct sk_buff *skb)
> +{
> +	struct hci_dev *hdev = (struct hci_dev *) skb->dev;
> +	struct vamp_data *data;
> +
> +	BT_DBG("%s", hdev->name);
> +
> +	if (!hdev) {
> +		BT_ERR("Frame for unknown HCI device (hdev=NULL)");
> +		return -ENODEV;
> +	}
> +
> +	if (!test_bit(HCI_RUNNING, &hdev->flags))
> +		return -EBUSY;
> +
> +	data = hci_get_drvdata(hdev);
> +
> +	skb_queue_tail(&data->txq, skb);
> +
> +	schedule_work(&data->work);

I don't understand the need for the asynchronous handling.

johannes

