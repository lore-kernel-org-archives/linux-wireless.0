Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42550 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1KIWcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 17:32:10 -0500
Received: by bke11 with SMTP id 11so1793215bke.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 14:32:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320874522.3845.109.camel@jlt3.sipsolutions.net>
References: <4EBAF088.2040406@broadcom.com> <1320874522.3845.109.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 10 Nov 2011 00:31:52 +0200
Message-ID: <CA+XVXfcUvRfqECfyH8yvkKmA06VpZXSjYAEMLDR_kHEDdt5q3A@mail.gmail.com> (sfid-20111109_233214_018461_8CB0D9BE)
Subject: Re: 3.2-rc1: system locks up upon inserting brcmsmac
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 9, 2011 at 23:35, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2011-11-09 at 22:28 +0100, Arend van Spriel wrote:
>> Hi John,
>>
>> I merged wireless-testing master with our main development branch and
>> got a hanging system. So I tested your master branch after that and the
>> same result. Given the kernel log it may be the commit mentioned below
>> although I did not bisect it yet.
>>
>> 077a91548 mac80211: support adding IV-room in the skb for CCMP keys
>
> Yeah that commit looks like it would add the bug -- it should check
> info->control.hw_key before the second test of
> IEEE80211_KEY_FLAG_PUT_IV_SPACE in ccmp_encrypt_skb.
>
> Try
>
> -       if (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)
> +       if (info->control.hw_key && info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)
>

Ah sorry about that :)

Johannes - would you like me to send a proper patch or are you taking
care of this?

Arik
