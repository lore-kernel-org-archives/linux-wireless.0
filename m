Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34361 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1HWOuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 10:50:03 -0400
Received: by vws1 with SMTP id 1so150662vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 07:50:01 -0700 (PDT)
Message-ID: <4E53BE15.3080207@lwfinger.net> (sfid-20110823_165006_307901_A47B6EB8)
Date: Tue, 23 Aug 2011 09:49:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH 1/5] rtlwifi: Install updated rate-mapping routine
References: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net> <1314049818-21839-2-git-send-email-Larry.Finger@lwfinger.net> <CAOiHx==qGMcTm_2nW4ktO=HzGGLrdjX2cqkb2Aj=0qANfuMGBg@mail.gmail.com>
In-Reply-To: <CAOiHx==qGMcTm_2nW4ktO=HzGGLrdjX2cqkb2Aj=0qANfuMGBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/23/2011 06:12 AM, Jonas Gorski wrote:
> Hi,
>
> On 22 August 2011 23:50, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> +int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
>> +                        bool isht, u8 desc_rate, bool first_ampdu)
>
> first_ampdu is never used in this function, is this intentional? I see
> the (later) removed functions change the default based on this, but
> without much knowledge of 802.11 I can't tell whether this actually
> makes sense, etc. ;-).

Good catch. When the routine was rewritten, that need for that boolean was 
eliminated, but neither Realtek nor I realized that we now have an unused 
argument. That is essentially a forest/trees problem. I will fix it.

Larry
