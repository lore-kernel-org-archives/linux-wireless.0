Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:48476 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab3J2O2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 10:28:25 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"Mark Cave-Ayland" <mark.cave-ayland@ilande.co.uk>,
	<netdev@vger.kernel.org>, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH NEXT] rtlwifi: Fix endian error in extracting packet type
References: <1383002903-8746-1-git-send-email-Larry.Finger@lwfinger.net>
	<1383005246.3779.61.camel@bwh-desktop.uk.level5networks.com>
Date: Tue, 29 Oct 2013 15:27:41 +0100
In-Reply-To: <1383005246.3779.61.camel@bwh-desktop.uk.level5networks.com> (Ben
	Hutchings's message of "Tue, 29 Oct 2013 00:07:26 +0000")
Message-ID: <87y55cf8yq.fsf@nemi.mork.no> (sfid-20131029_152832_715704_222657E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Hutchings <bhutchings@solarflare.com> writes:

>> @@ -1077,8 +1077,8 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
>>  
>>  	ip = (struct iphdr *)((u8 *) skb->data + mac_hdr_len +
>>  			      SNAP_SIZE + PROTOC_TYPE_SIZE);
>> -	ether_type = *(u16 *) ((u8 *) skb->data + mac_hdr_len + SNAP_SIZE);
>> -	/*	ether_type = ntohs(ether_type); */
>> +	ether_type = be16_to_cpu(*(__be16 *)((u8 *)skb->data + mac_hdr_len +
>> +					     SNAP_SIZE));
>>  
>>  	if (ETH_P_IP == ether_type) {
>>  		if (IPPROTO_UDP == ip->protocol) {
>
> This crazy function also says that *all* IPv6 frames are special, which
> apparently means that on TX they should get sent at the lowest possible
> bit rate.  So I think this is going to cause a regression for IPv6
> throughput unless you remove that case.
>
> The DHCP case is also not validating IP and UDP header lengths against
> the packet length, though this may be harmless in practice.

It's not validating the upper 8 bits of the port numbers either, so it
will hit random UDP traffic in addition to DHCP. 

But it was good to see this function now. I was wondering how to support
some buggy 3G modem firmware without ugly hacks. Seems there will always
be worse hacks in drivers/net, no matter what I do :-)


Bjørn
