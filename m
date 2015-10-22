Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out22.sjc.mx.trendmicro.com ([216.99.131.79]:64699 "EHLO
	out22.sjc.mx.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725AbbJVIXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 04:23:44 -0400
Received: from out17.sjc.mx.trendmicro.com (unknown [216.99.131.74])
	by out22.sjc.mx.trendmicro.com (Postfix) with ESMTP id EE49F9BB8DA
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2015 07:50:33 +0000 (UTC)
Received: from relay05.sjc.mx.trendmicro.com (unknown [10.30.239.131])
	by out17.sjc.mx.trendmicro.com (Postfix) with ESMTP id D10AA98165D
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2015 07:50:32 +0000 (UTC)
Received: from thinktube.com (unknown [111.68.225.247])
	by relay05.sjc.mx.trendmicro.com (Postfix) with ESMTP id 71DCF98051B
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2015 07:50:32 +0000 (UTC)
Received: from unknown (HELO [192.168.5.9]) (br1@[188.85.79.213])
          (envelope-sender <br1@thinktube.com>)
          by 111.68.225.247 (qmail-ldap-1.03) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 22 Oct 2015 07:50:31 -0000
Subject: Re: [PATCH] rtl8xxxu: Enable data frame reception in rtl8xxxu_start
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Bruno Randolf <br1@einfach.org>
References: <1445462932-23679-1-git-send-email-br1@einfach.org>
 <wrfjoafrrf1s.fsf@redhat.com>
Cc: linux-wireless@vger.kernel.org
From: Bruno Randolf <br1@thinktube.com>
Message-ID: <56289543.1070008@thinktube.com> (sfid-20151022_102351_718422_E4750007)
Date: Thu, 22 Oct 2015 08:50:27 +0100
MIME-Version: 1.0
In-Reply-To: <wrfjoafrrf1s.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2015 12:13 AM, Jes Sorensen wrote:
> Bruno Randolf <br1@einfach.org> writes:
>> mac80211 documentation says, the ieee80211_ops.start callback "must turn on
>> frame reception (for possibly enabled monitor interfaces.)". If not a single
>> monitor interface does not receive data frames.
>>
>> Similarly we should not change the data reception based on the association
>> state.
>>
>> Signed-off-by: Bruno Randolf <br1@einfach.org>
>> ---
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 12 ++----------
>>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> Bruno,
> 
> Thanks - I am not 100% convinced about this one. I don't think we should
> tell the firmware to pass up data frames before we have negotiated the
> connection.
> 
> It's true that for monitor mode, we need to enable it if all packets
> are requested. Looking at iw there is an option where it only requests
> control packets, and one for all, etc. However for non monitor mode, we
> shouldn't pass all data packets up to the stack, resulting and have
> mac80211 parse them all.

But mac80211 requests us to do so - please see include/net/mac80211.h
line 2576 or
https://www.kernel.org/doc/htmldocs/80211/API-struct-ieee80211-ops.html

I know you are focusing on STA mode at the moment, but
enabling/disabling data reception on association is not correct for most
other modes.

Also don't be afraid of too many frames being passed. In the initial
setting (without a monitor interface) the RCR RCR_ACCEPT_AP bit is not
set and the RCR_CHECK_BSSID_* bits are set as well.

bruno

