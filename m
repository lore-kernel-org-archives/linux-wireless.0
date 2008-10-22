Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:58211 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYJVOTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 10:19:42 -0400
Received: by yw-out-2324.google.com with SMTP id 9so547654ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 07:19:41 -0700 (PDT)
Message-ID: <48FF3676.1060909@gmail.com> (sfid-20081022_161949_669829_629890D9)
Date: Wed, 22 Oct 2008 16:19:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Gregory Nietsky <gregory@dnstelecom.co.za>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 1/1] Ath5k: add AP mode
References: <1223844850-26551-1-git-send-email-jirislaby@gmail.com> <40f31dec0810211108l6700d806o4804b43d9fe47bf7@mail.gmail.com>
In-Reply-To: <40f31dec0810211108l6700d806o4804b43d9fe47bf7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/21/2008 08:08 PM, Nick Kossifidis wrote:
> 2008/10/12 Jiri Slaby <jirislaby@gmail.com>:
>> Add support for AP mode. This involves:
>> - enablement in ath5k_beacon_config -- initialize beacon timer
>> - add AP to the supported modes in ath5k_add_interface
>> - handle beacon change even for AP in ath5k_config_interface
>> - remove useless test for IBSS in ath5k_beacon_update
>>
>> Note that it doesn't enable the AP mode for the driver. It must
>> be enabled by NL80211_IFTYPE_AP bit added to interface_modes.
[...]
> a) It won't work without the following as Gregory pointed out

This was intentional, see the changelog.

> b) For some reason it only works with 5212/5213 cards, i tested it on
> a 5413 and an 2425 and it didn't work (hostapd seems to hang).

I've ordered 5413 ;), will come with updates.

Thanks for testing, Nick.
