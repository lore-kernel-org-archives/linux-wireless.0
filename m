Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46130 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2EGL7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 07:59:32 -0400
Message-ID: <1336391971.4325.25.camel@jlt3.sipsolutions.net> (sfid-20120507_135938_408601_EDEF46A3)
Subject: Re: [RFCv2 1/6] mac80211: softamp: Adds Bluetooth Software AMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 07 May 2012 13:59:31 +0200
In-Reply-To: <20120507115608.GD19002@aemeltch-MOBL1>
References: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 <1335273460-12682-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 <1336390879.4325.18.camel@jlt3.sipsolutions.net>
	 <20120507115608.GD19002@aemeltch-MOBL1>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-07 at 14:56 +0300, Andrei Emeltchenko wrote:
> Hi Johannes,
> 
> On Mon, May 07, 2012 at 01:41:19PM +0200, Johannes Berg wrote:
> > On Tue, 2012-04-24 at 16:17 +0300, Andrei Emeltchenko wrote:
> > 
> > > --- a/include/linux/nl80211.h
> > > +++ b/include/linux/nl80211.h
> > > @@ -1546,6 +1546,7 @@ enum nl80211_iftype {
> > >  	NL80211_IFTYPE_MESH_POINT,
> > >  	NL80211_IFTYPE_P2P_CLIENT,
> > >  	NL80211_IFTYPE_P2P_GO,
> > > +	NL80211_IFTYPE_BLUETOOTH_SOFTAMP,
> > 
> > That should probably be a separate patch also updating cfg80211 (and
> > maybe mac80211) where needed (at least to suppress the warnings you
> > saw). Also documentation is needed.
> > 
> > > @@ -211,6 +212,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
> > >  	case NL80211_IFTYPE_STATION:
> > >  	case NL80211_IFTYPE_MONITOR:
> > >  	case NL80211_IFTYPE_ADHOC:
> > > +	case NL80211_IFTYPE_BLUETOOTH_SOFTAMP:
> > >  		/* no special treatment */
> > >  		break;
> > 
> > You should never be able to come here with this interface type -- maybe
> > make it a warning or something.
> > 
> > > +static int vamp_send_frame(struct sk_buff *skb)
> > > +{
> > > +	struct hci_dev *hdev = (struct hci_dev *) skb->dev;
> > > +	struct vamp_data *data;
> > > +
> > > +	BT_DBG("%s", hdev->name);
> > > +
> > > +	if (!hdev) {
> > > +		BT_ERR("Frame for unknown HCI device (hdev=NULL)");
> > > +		return -ENODEV;
> > > +	}
> > > +
> > > +	if (!test_bit(HCI_RUNNING, &hdev->flags))
> > > +		return -EBUSY;
> > > +
> > > +	data = hci_get_drvdata(hdev);
> > > +
> > > +	skb_queue_tail(&data->txq, skb);
> > > +
> > > +	schedule_work(&data->work);
> > 
> > I don't understand the need for the asynchronous handling.
> 
> This is standard way for hci dev. Can be changed so that skb is handled
> right here.

"standard" doesn't explain why it's needed though, and I don't think it
is needed here.

johannes

