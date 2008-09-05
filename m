Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51910 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbYIEWu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 18:50:26 -0400
From: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"Zhu, Yi" <yi.zhu@intel.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 5 Sep 2008 15:50:04 -0700
Subject: RE: [PATCH 08/39] iwl3945: replace association and beacon hooks
	with bss_info_changed cb
Message-ID: <B27EBC40D200ED48A3F4CC2EBEABAE0B14F7F6C8@orsmsx501.amr.corp.intel.com> (sfid-20080906_005030_709665_A143163F)
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
	 (sfid-20080903_053112_984921_AFC1F0BC)
 <1220649265.11109.29.camel@johannes.berg>
In-Reply-To: <1220649265.11109.29.camel@johannes.berg>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Johannes Berg
Sent: Friday, September 05, 2008 2:14 PM
To: Zhu, Yi
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; Kolekar, Abhijeet
Subject: Re: [PATCH 08/39] iwl3945: replace association and beacon hooks with bss_info_changed cb

On Wed, 2008-09-03 at 11:26 +0800, Zhu Yi wrote:
> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
>
> Let mac80211 and bss_info_changed callback handle the association and
> beacon changes.

Nice.


> @@ -688,87 +688,6 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
>
>       switch (le16_to_cpu(header->frame_control) & IEEE80211_FCTL_FTYPE) {
>       case IEEE80211_FTYPE_MGMT:

You can, umm, simplify all this code a bit now:
---------
Patch is on way :-)
Thanks
Abhijeet
---------

        if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
                iwl3945_pass_packet_to_mac80211(priv, rxb, &rx_status);
                return;
        }

        switch (le16_to_cpu(header->frame_control) & IEEE80211_FCTL_FTYPE) {
        case IEEE80211_FTYPE_MGMT:
        case IEEE80211_FTYPE_DATA:
                /* fall through */
        default:
                iwl3945_pass_packet_to_mac80211(priv, rxb, &rx_status);
                break;
        }


a single line can express the same :)

johannes
