Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:62726 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaHLImy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 04:42:54 -0400
Message-ID: <53E9D38B.1060509@broadcom.com> (sfid-20140812_104259_379349_4BDF2D1F)
Date: Tue, 12 Aug 2014 10:42:51 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "C. McPherson" <ccmcphe@verizon.net>
CC: <backports@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Netlink Question
References: <53E917AB.3020002@verizon.net>
In-Reply-To: <53E917AB.3020002@verizon.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

Not really a backports question so adding linux-wireless

On 08/11/2014 09:21 PM, C. McPherson wrote:
> I have some private WiFi ioctl's that are associated with a couple of
> drivers and I would like to convert those private ioctl's into netlink.
> Does anyone know if there is any documentation on this or a URL that I
> could reference before I attempt?

I guess the "private WiFi ioctl's" you are referring to are the ones 
used in Android wpa_supplicant driver_cmd lib? There is no real cookbook 
on how to add nl80211 commands (maybe I am wrong here), but there are 
sufficient patches to be found in the linux-wireless archive. A recent 
one about key management offload adds a couple of commands and 
attributes which may give an idea what is needed:

http://mid.gmane.org/1406076875-8549-1-git-send-email-clanctot@qca.qualcomm.com

Obviously, you need to modify the "couple of drivers" to deal with the 
nl80211 netlink commands.

Regards,
Arend

> Thanks in advance
> Clyde
>
> --
> To unsubscribe from this list: send the line "unsubscribe backports" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

