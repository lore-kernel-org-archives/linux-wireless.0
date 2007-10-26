Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:49584 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXJZKxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 06:53:16 -0400
Received: by nf-out-0910.google.com with SMTP id g13so751347nfb
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 03:53:15 -0700 (PDT)
Message-ID: <4721C717.5050501@gmail.com> (sfid-20071026_115325_629308_44276C9D)
Date: Fri, 26 Oct 2007 12:53:11 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Williams <dcbw@redhat.com>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [PATCH] Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to
 dynamic wep network
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>	 <1193127280.3069.261.camel@debian.sh.intel.com>	 <1193148453.8648.20.camel@localhost.localdomain>	 (sfid-20071023_150810_118446_E87EE8F5)  <1193161034.7733.38.camel@johannes.berg>	 <1193238423.2557.41.camel@localhost.localdomain>	 <1193318969.6092.19.camel@johannes.berg>  <4721C23E.501@gmail.com>	 (sfid-20071026_113240_433638_78FBCECA) <1193395405.4406.51.camel@johannes.berg>
In-Reply-To: <1193395405.4406.51.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> ieee80211_ioctl_siwauth in ieee80211_ioctl.c sets the 
>> key_management_enabled variable if the value passed to the ioctl is not 
>> 0 to true:
>> sdata->u.sta.key_management_enabled = !!data->value;
>> why !!data->value ?  that should be the same as data->value ...
>>     
>
> Nope. Think again :) !! normalises to 0/1 rather than 0/!=0
>
>   
oh.. ok ;)
>> now to wpa_supplicant:
>> wpa_driver_wext_keymgmt2wext in driver_wext.c  returns 
>> IW_AUTH_KEY_MGMT_802_1 (which is defined as 1) (when dynamic wep is 
>> used) wpa_driver_wext_set_auth_param than passes the value using 
>> ioctl(drv->ioctl_sock, SIOCSIWAUTH, &iwr) to mac80211.
>>     
>
> Are you sure it returns IW_AUTH_KEY_MGMT_802_1(X)? My assumption was
> that this is what goes wrong.
>
>   
as I said before I don't have access to the ap right now but here:

static int wpa_driver_wext_keymgmt2wext(int keymgmt)
{
    switch (keymgmt) {
    case KEY_MGMT_802_1X:
        return IW_AUTH_KEY_MGMT_802_1X;

that should be tha case for dynamic wep. (key_mgmt=IEEE8021X needed in 
wpa_supplicant.conf)
>> ieee80211_privacy_mismatch checks for
>> if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL) ||
>>         ifsta->key_management_enabled)
>>
>> and returns 0 because ifsta->key_management_enabled  true in this case 
>> !!1 -> 1
>>     
>
> Which is fine, privacy_mismatch() returns 0 if there's no "mismatch" and
> we should hence proceed with the association.
>
> That's bogus, you misunderstood the return value of privacy_mismatch()
>   
ok thx for explaing it.
