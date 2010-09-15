Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35496 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0IOB6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 21:58:42 -0400
Received: by pvg2 with SMTP id 2so2592792pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 18:58:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009151047.38880.br1@einfach.org>
References: <AANLkTi=azJS6bn7-=Bbb--ibACaQWqv4ZGLMUpfxynm7@mail.gmail.com>
 <AANLkTi=8p2umy+m4emdqKMb=eTYiLTsR3ZENwFaJyoe8@mail.gmail.com>
 <AANLkTimfyZ4N9LWXi-Tbk-xsVisa3C=B=n4s3S6Lf5HV@mail.gmail.com> <201009151047.38880.br1@einfach.org>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 15 Sep 2010 11:58:22 +1000
Message-ID: <AANLkTikY2vkUDQaC-iAZPrC09P-8-jcgAt84LGY-z=AE@mail.gmail.com>
Subject: Re: [ath5k-devel] [support] ath5k contention windows
To: Bruno Randolf <br1@einfach.org>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 11:47 AM, Bruno Randolf <br1@einfach.org> wrote:
> On Wed September 15 2010 09:44:09 Jonathan Guerin wrote:
>> The timings I used were from the 802.11-2007 spec.
>> SIFS, DIFS & Slot Time: Table 17-15—OFDM PHY characteristics
>> NDPS values: Table 17-3—Modulation-dependent parameters
>> txtime calculations: Section 17.4.3 OFDM TXTIME calculation
>>
>> Here are the functions I use to do the basics:
>> int16_t ndbps(uint8_t rate_Mbps)
>> {
>>   //Radiotap returns rate in 500kbps units
>>   rate_Mbps/=2;
>>
>>    static const uint8_t rate_nsyms[][2] = {
>>       {  6,  24 },
>>       {  9,  36 },
>>       { 12,  48 },
>>       { 18,  72 },
>>       { 24,  96 },
>>       { 36, 144 },
>>       { 48, 192 },
>>       { 54, 216 }
>
> this is rate * 4
>
>>    };
>>    static const size_t nof_rate_nsyms = sizeof(rate_nsyms) /
>> sizeof(rate_nsyms[0]);
>>    for(size_t i = 0; i < nof_rate_nsyms; ++i) {
>>       if(rate_Mbps == rate_nsyms[i][0]) {
>>          return rate_nsyms[i][1];
>>       }
>>    }
>>    return -1;
>> }
>>
>> int getTXTime(int rate, int noctets) {
>>   uint16_t usecs = 0;
>>   const int16_t nof_bps = ndbps(rate);
>>
>>   int chan_rate = 1;
>>
>>   if(-1 != nof_bps) {
>>     const uint16_t preamble = 16 * chan_rate;
>>     const uint16_t signal = 4 * chan_rate;
>>     const uint16_t tsym = 4 * chan_rate;
>>     const uint16_t nsyms = ceill((16.0 + 8.0 * (noctets) + 6.0) / nof_bps);
>>     usecs = preamble + signal + tsym * nsyms;
>>   }
>>
>>   return(usecs);
>
> if you compare that to the code in mac80211/util.c ieee80211_frame_duration():
>
>                dur = 16; /* SIFS + signal ext */
>                dur += 16; /* 17.3.2.3: T_PREAMBLE = 16 usec */
>                dur += 4; /* 17.3.2.3: T_SIGNAL = 4 usec */
>                dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10,
>                                        4 * rate); /* T_SYM x N_SYM */
>
> it is equivalent, except that you don't add 16 /* SIFS + signal ext */. is
> this intended?

Yes, I add the SIFS later when I calculate a full DATA+ACK exchange
for other works, hence why this function does not include it. What is
signal ext there? SIFS should already be 16 on its own...

>
> bruno
>

Thanks,

Jonathan
