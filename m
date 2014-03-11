Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54287 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbaCKJgz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 05:36:55 -0400
Message-ID: <531ED921.5040601@openwrt.org> (sfid-20140311_103658_647797_CE216D94)
Date: Tue, 11 Mar 2014 10:36:33 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3.14] ath9k: fix ps-poll responses under a-mpdu sessions
References: <1393073299-4831-1-git-send-email-nbd@openwrt.org> <CAGXE3d_wmuDi2kUjvhLGxSFMAxwcYgjLXJ78fPgyHmDN7m0cSw@mail.gmail.com>
In-Reply-To: <CAGXE3d_wmuDi2kUjvhLGxSFMAxwcYgjLXJ78fPgyHmDN7m0cSw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-03-11 10:28, Helmut Schaa wrote:
> On Sat, Feb 22, 2014 at 1:48 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> When passing tx frames to the U-APSD queue for powersave poll responses,
>> the ath_atx_tid pointer needs to be passed to ath_tx_setup_buffer for
>> proper sequence number accounting.
>>
>> This fixes high latency and connection stability issues with ath9k
>> running as AP and a few kinds of mobile phones as client, when PS-Poll
>> is heavily used
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
> 
> Hi Felix,
> 
> this commit introduced a regression for me when using Intel Win7
> clients on a ath9k AP.
> 
> I was not able to track the exact issue down yet :( but it seems to be
> related to the Intel
> client constantly tearing down the BA session and entering/leaving PS mode.
> 
> Any idea?
Please make some packet captures and describe more clearly what the
regression is. Do you see connections stalling, big latencies, etc?

- Felix
