Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:43336 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754788AbdKNOXa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 09:23:30 -0500
Message-ID: <1510669408.2030.23.camel@sipsolutions.net> (sfid-20171114_152333_197817_51805569)
Subject: Re: [RFC] cfg80211: Implement Multiple BSSID capability in scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Peng Xu <pxu@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Sara Sharon <sara.sharon@intel.com>
Date: Tue, 14 Nov 2017 15:23:28 +0100
In-Reply-To: <4927d2288442486788cd5b4d0492537a@NASANEXM01F.na.qualcomm.com>
References: <1509554358-10473-1-git-send-email-jouni@qca.qualcomm.com>
         <1510664296.2030.22.camel@sipsolutions.net>
         <4927d2288442486788cd5b4d0492537a@NASANEXM01F.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-11-14 at 14:20 +0000, Peng Xu wrote:
> > 
> > > +			if (tmp_old[0] == WLAN_EID_VENDOR_SPECIFIC) {
> > > +				if (!memcmp(tmp_old + 2, tmp + 2, 5)) {
> > > +					/* same vendor ie, copy from new ie
> > 
> > */
> > > +					memcpy(pos, tmp, tmp[1] + 2);
> > > +					pos += tmp[1] + 2;
> > > +				} else {
> > > +					memcpy(pos, tmp_old, tmp_old[1] +
> > 
> > 2);
> > > +					pos += tmp_old[1] + 2;
> > 
> > This seems really strange. What's 5? Should it be 4, so you have
> > OUI+subelement ID?
> > 
> 
> It is OUI + type + subTye.

Ah, right, type/subtype.

Still, this is problematic, because there's nothing that says that the
vendor IE must have OUI + type + subtype, the spec only says OUI +
vendor specific data.

This may be right for the WFA/Microsoft OUI, but not necessary anything
else?

johannes
