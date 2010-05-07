Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:48896 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab0EGTKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 15:10:19 -0400
Message-ID: <4BE46584.5060304@create-net.org>
Date: Fri, 07 May 2010 21:09:56 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Packet injection with ath9k
References: <4BE43C18.2030806@create-net.org> <j2v69e28c911005070935wb720d757labf3a0484aedefb8@mail.gmail.com>
In-Reply-To: <j2v69e28c911005070935wb720d757labf3a0484aedefb8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

well, that is what i wanted to understand. These are the struct
that I'm using to compose the rediotap header:

struct ieee80211_radiotap_header {
     u_int8_t    it_version;
     u_int8_t    it_pad;
     u_int16_t       it_len;
     u_int32_t       it_present;
} __attribute__((__packed__));

struct click_radiotap_header {
     struct ieee80211_radiotap_header wt_ihdr;
     u_int8_t    wt_rate;
     u_int8_t    wt_txpower;
     u_int8_t        wt_rts_retries;
     u_int8_t        wt_data_retries;
};

The flags are set in order to take into account the fields that I
specify. But i do not know at which point the frame are
dropped.

R.

On 05/07/2010 06:35 PM, Gábor Stefanik wrote:
> Hi!
> Are you sure it is not your injector that is having alignment issues?
> AFAIK the radiotap parser explicitly uses endianness-aware function
> everywhere.
>
> On Fri, May 7, 2010 at 6:13 PM, Roberto Riggio
> <roberto.riggio@create-net.org>  wrote:
>    
>> Hi,
>>
>> I'm writing an application to inject traffic over a wireless interface. This
>> app
>> is working fine on an x86 machine. However if i compile the same app for
>> an arm platform, no frame are sent over the wireless interface (ath9k).
>>
>> I'm guessing that this is because of some alignment issues but i cannot
>> track
>> the piece of code that is actually parsing the frame. I've found the
>> __ieee80211_parse_tx_radiotap in net/mac80211/tx.c function, but it is
>> not called when i try to inject some traffic, so the frame are dropped
>> before that.
>>
>> Any hints?
>>
>> Thanks
>> R.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>      
>
>
>    

