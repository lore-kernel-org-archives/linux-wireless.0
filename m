Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36101 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1EDQ2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 12:28:36 -0400
Received: by vxi39 with SMTP id 39so1331648vxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 09:28:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304513847.3563.15.camel@jlt3.sipsolutions.net>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
 <1304467039-7730-5-git-send-email-javier@cozybit.com> <1304513847.3563.15.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 4 May 2011 09:28:15 -0700
Message-ID: <BANLkTikxrCvdmNDX-YwFxD3C-k_sMS=POA@mail.gmail.com> (sfid-20110504_182839_464922_596D8D44)
Subject: Re: [PATCH 04/13] open80211s: Stop using zero for address 3 in mesh
 plink mgmt frames
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 4, 2011 at 5:57 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-05-03 at 16:57 -0700, Javier Cardona wrote:
>> Previous versions of 11s draft used the all zeroes address.  Current
>> draft uses the same address as address 2.
>
> There's also some code in net/wireless/scan.c that should be removed or
> changed then I think?

Ah, I see:

        if (is_zero_ether_addr(res->pub.bssid)) {
                /* must be mesh, verify */
                meshid = cfg80211_find_ie(WLAN_EID_MESH_ID,
                                          res->pub.information_elements,
                                          res->pub.len_information_elements);

I'll review that file and send send a follow up patch.

Thanks,

Javier
