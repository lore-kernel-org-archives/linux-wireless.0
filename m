Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54575 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYHHOSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 10:18:50 -0400
MIME-Version: 1.0
Subject: RE: [PATCH 1/2] mac80211: change number of pre-assoc scans
Date: Fri, 8 Aug 2008 17:18:45 +0300
Message-ID: <1879838866982C46A9CB3D56BA49ADEB0542F64C@hasmsx411.ger.corp.intel.com> (sfid-20080808_161853_391051_E89B69ED)
In-Reply-To: <43e72e890808071559k207a34e3we21cb2633f5e248d@mail.gmail.com>
References: <1218149447-28968-1-git-send-email-tomas.winkler@intel.com> <43e72e890808071559k207a34e3we21cb2633f5e248d@mail.gmail.com>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
Cc: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	"Zhu, Yi" <yi.zhu@intel.com>, <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> -       int auth_tries, assoc_tries;
>> +       int assoc_scan_tries; /* number of scans done pre-association
*/
>> +       int auth_tries; /* retries for auth req */
>> +       int assoc_tries; /* retries for assoc req */
>
> This last variable seems unused.
>

If you mean auth_tries or assoc_tries they are being used in other
flows.

>>                ieee80211_sta_reset_auth(dev, ifsta);
>>                return 0;
>>        } else {
>> -               if (ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE)
{
>> +               if (ifsta->assoc_scan_tries <
IEEE80211_ASSOC_SCANS_MAX_TRIES) {
>> +                       ifsta->assoc_scan_tries++;
>>                        if (ifsta->flags &
IEEE80211_STA_AUTO_SSID_SEL)
>>                                ieee80211_sta_start_scan(dev, NULL,
0);
>>                        else
>
> Interesting, is there a race then?
>

Not more then before this patch :).. if you mean protecting the mlme
states I think this should be carefully handled, for sure not under this
patch 
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

