Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58462 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaHLJci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 05:32:38 -0400
MIME-Version: 1.0
In-Reply-To: <53E9D38B.1060509@broadcom.com>
References: <53E917AB.3020002@verizon.net> <53E9D38B.1060509@broadcom.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 12 Aug 2014 15:02:16 +0530
Message-ID: <CABPxzYK3wwGigXnPL7ZoQYTyenqf0kcNs4naxB2+8bsdeARj9g@mail.gmail.com> (sfid-20140812_113242_602444_4F29A192)
Subject: Re: Netlink Question
To: Arend van Spriel <arend@broadcom.com>
Cc: "C. McPherson" <ccmcphe@verizon.net>, backports@vger.kernel.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 12, 2014 at 2:12 PM, Arend van Spriel <arend@broadcom.com> wrote:
>
> + linux-wireless
>
> Not really a backports question so adding linux-wireless
>
> On 08/11/2014 09:21 PM, C. McPherson wrote:
>>
>> I have some private WiFi ioctl's that are associated with a couple of
>> drivers and I would like to convert those private ioctl's into netlink.
>> Does anyone know if there is any documentation on this or a URL that I
>> could reference before I attempt?
>
>
> I guess the "private WiFi ioctl's" you are referring to are the ones used in Android wpa_supplicant driver_cmd lib? There is no real cookbook on how to add nl80211 commands (maybe I am wrong here), but there are sufficient patches to be found in the linux-wireless archive. A recent one about key management offload adds a couple of commands and attributes which may give an idea what is needed:
>
> http://mid.gmane.org/1406076875-8549-1-git-send-email-clanctot@qca.qualcomm.com
>
> Obviously, you need to modify the "couple of drivers" to deal with the nl80211 netlink commands.
>
We had same requirement in our driver,  we have patched the iw to send
custom commands specific to our hardware and used NL80211_CMD_TESTMODE
to process and send it to driver.
