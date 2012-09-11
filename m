Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46889 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2IKGrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 02:47:00 -0400
Received: by obbuo13 with SMTP id uo13so240417obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2012 23:47:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj9845-oLbFK7_i5hL6bWMF4=oTJ4avDkEv3kpJGXCpaiSiQ@mail.gmail.com>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<1346746298.3737.0.camel@jlt4.sipsolutions.net>
	<CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
	<20120904102204.GA2541@w1.fi>
	<CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com>
	<CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com>
	<1346758521.3737.28.camel@jlt4.sipsolutions.net>
	<CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
	<20120905071653.GB3629@w1.fi>
	<CAEFj985iHQJTAqXBkz56BDPodHb9q0Z=x3S5Q43UwA5vU-mfMw@mail.gmail.com>
	<20120905080336.GA4747@w1.fi>
	<CAEFj986i9XUcEN0i2y5=YLh2RX8MZOf+60i8XL4jMiq5-JcJ6Q@mail.gmail.com>
	<CAJ-Vmonesc=VPMUJgS1GHTUS-Xj_BTohv0rQ9ZS+rW-761g_8w@mail.gmail.com>
	<87zk4y3tsz.fsf@purkki.adurom.net>
	<CAEFj9845-oLbFK7_i5hL6bWMF4=oTJ4avDkEv3kpJGXCpaiSiQ@mail.gmail.com>
Date: Tue, 11 Sep 2012 09:46:59 +0300
Message-ID: <CAFtRNNzdXFbcxNw0M7oYsvidiLnckycy4V73Y+pG4oUNqeCJvQ@mail.gmail.com> (sfid-20120911_084705_665704_89F6403B)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Nick Kossifidis <mickflemm@gmail.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Kalle Valo <kvalo@adurom.com>, Adrian Chadd <adrian@freebsd.org>,
	Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mcgrof@qca.qualcomm.com, ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/10 Yeoh Chun-Yeow <yeohchunyeow@gmail.com>:
> Hi, all
>
> For your information, my submitted patch has allowed me to do the
> following and mainly to setup the secured mesh 802.11s using authsae:
>
> 1. Key installations for the following:
> /* key to protect integrity of multicast mgmt frames tx*/
> install_key(nlcfg, NULL, CIPHER_AES_CMAC, NL80211_KEYTYPE_GROUP, 4, mgtk_tx);
> /* key to encrypt multicast data traffic */
> install_key(nlcfg, NULL, CIPHER_CCMP, NL80211_KEYTYPE_GROUP, 0, mgtk_tx);
> /* key to encrypt/decrypt unicast data AND mgmt traffic to/from this peer */
> install_key(&nlcfg, peer, CIPHER_CCMP, NL80211_KEYTYPE_PAIRWISE, 0, mtk);
> /* key to decrypt multicast data traffic from this peer */
> install_key(&nlcfg, peer, CIPHER_CCMP, NL80211_KEYTYPE_GROUP, 0, peer_mgtk);
> /* to check integrity of multicast mgmt frames from this peer */
> install_key(&nlcfg, peer, CIPHER_AES_CMAC, NL80211_KEYTYPE_GROUP, 4, peer_mgtk);
>
> 2. By using the submitted patch, how ever as Jouni has pointed out
> that testing with ath5k implementation alone may not be correct, due
> to the following statement:
> If the CCMP processing is done incorrectly, they could both mangle the
> results in the same way to hide the issue.
>
> thus I revert back by not disabling the IEEE80211_KEY_FLAG_SW_MGMT.
> However, with this, it has showed that robust unicast management frame
> is encrypted in SW but is decrypted wrongly in SW (perhaps HW decrypt
> it due to the HW accl enabling for unicast data frame).
>
> Hope this help.
>
> Thanks.
>
> Regards,
> Chun-Yeow
>
> On Mon, Sep 10, 2012 at 9:13 PM, Kalle Valo <kvalo@adurom.com> wrote:
>> Adrian Chadd <adrian@freebsd.org> writes:
>>
>>> Yeoh - can you please email me privately with a summary of what you
>>> implemented, what you've tested and what worked / what didn't work?
>>
>> Why privately? Better to have all the information public, you never know
>> if someone finds the info from the web and picks up the work.
>>
>> --
>> Kalle Valo

Have you tried disabing RX or TX only encryption/decryption on hw
trough PCU DIAG register ?

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
