Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52967 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaELSfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 14:35:32 -0400
Date: Tue, 13 May 2014 00:06:00 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Sachin Ahuja <sahuja@codeaurora.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [PATCH v2] cfg80211: avoid restoring the regulatory during
 disconnect
Message-ID: <20140512183558.GA25030@qca.qualcomm.com> (sfid-20140512_203545_264029_E3BE05D4)
References: <1399631327-23379-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1399903203.4337.9.camel@jlt4.sipsolutions.net>
 <20140512172136.GA9468@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20140512172136.GA9468@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 12, 2014 at 10:51:37PM +0530, Rajkumar Manoharan wrote:
> On Mon, May 12, 2014 at 04:00:03PM +0200, Johannes Berg wrote:
> > On Fri, 2014-05-09 at 15:58 +0530, Rajkumar Manoharan wrote:
> > 
> > > +static bool cfg80211_is_all_countryie_ignore(void)
> > > +{
> > > +	struct cfg80211_registered_device *rdev;
> > > +	struct wireless_dev *wdev;
> > > +
> > > +	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
> > > +		list_for_each_entry(wdev, &rdev->wdev_list, list) {
> > > +			wdev_lock(wdev);
> > > +			if (!(wdev->wiphy->regulatory_flags &
> > > +			      REGULATORY_COUNTRY_IE_IGNORE)) {
> > > +				wdev_unlock(wdev);
> > 
> > The locking here seems completely pointless.
> >
> locking is handled in same way of cfg80211_is_all_idle. Still
> want to remove locks?
> 
> > Also, maybe you can do something about the long lines, maybe with a
> > temporary variable?
> >
sorry for the noise. sent v3 patch.

-Rajkumar
