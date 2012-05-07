Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab2EGLzE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 07:55:04 -0400
Date: Mon, 7 May 2012 14:56:10 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv2 1/6] mac80211: softamp: Adds Bluetooth Software AMP
Message-ID: <20120507115608.GD19002@aemeltch-MOBL1> (sfid-20120507_135511_371184_57E7985E)
References: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1335273460-12682-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1336390879.4325.18.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336390879.4325.18.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Mon, May 07, 2012 at 01:41:19PM +0200, Johannes Berg wrote:
> On Tue, 2012-04-24 at 16:17 +0300, Andrei Emeltchenko wrote:
> 
> > --- a/include/linux/nl80211.h
> > +++ b/include/linux/nl80211.h
> > @@ -1546,6 +1546,7 @@ enum nl80211_iftype {
> >  	NL80211_IFTYPE_MESH_POINT,
> >  	NL80211_IFTYPE_P2P_CLIENT,
> >  	NL80211_IFTYPE_P2P_GO,
> > +	NL80211_IFTYPE_BLUETOOTH_SOFTAMP,
> 
> That should probably be a separate patch also updating cfg80211 (and
> maybe mac80211) where needed (at least to suppress the warnings you
> saw). Also documentation is needed.
> 
> > @@ -211,6 +212,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
> >  	case NL80211_IFTYPE_STATION:
> >  	case NL80211_IFTYPE_MONITOR:
> >  	case NL80211_IFTYPE_ADHOC:
> > +	case NL80211_IFTYPE_BLUETOOTH_SOFTAMP:
> >  		/* no special treatment */
> >  		break;
> 
> You should never be able to come here with this interface type -- maybe
> make it a warning or something.
> 
> > +static int vamp_send_frame(struct sk_buff *skb)
> > +{
> > +	struct hci_dev *hdev = (struct hci_dev *) skb->dev;
> > +	struct vamp_data *data;
> > +
> > +	BT_DBG("%s", hdev->name);
> > +
> > +	if (!hdev) {
> > +		BT_ERR("Frame for unknown HCI device (hdev=NULL)");
> > +		return -ENODEV;
> > +	}
> > +
> > +	if (!test_bit(HCI_RUNNING, &hdev->flags))
> > +		return -EBUSY;
> > +
> > +	data = hci_get_drvdata(hdev);
> > +
> > +	skb_queue_tail(&data->txq, skb);
> > +
> > +	schedule_work(&data->work);
> 
> I don't understand the need for the asynchronous handling.

This is standard way for hci dev. Can be changed so that skb is handled
right here.

Best regards 
Andrei Emeltchenko 
