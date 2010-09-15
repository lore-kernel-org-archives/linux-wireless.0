Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38303 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab0IOAoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 20:44:32 -0400
Received: by pzk34 with SMTP id 34so2585417pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 17:44:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=8p2umy+m4emdqKMb=eTYiLTsR3ZENwFaJyoe8@mail.gmail.com>
References: <AANLkTi=azJS6bn7-=Bbb--ibACaQWqv4ZGLMUpfxynm7@mail.gmail.com>
 <AANLkTik+KjxZSbaShYKq91WN7niZYvtETXbpgDPgj84L@mail.gmail.com> <AANLkTi=8p2umy+m4emdqKMb=eTYiLTsR3ZENwFaJyoe8@mail.gmail.com>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 15 Sep 2010 10:44:09 +1000
Message-ID: <AANLkTimfyZ4N9LWXi-Tbk-xsVisa3C=B=n4s3S6Lf5HV@mail.gmail.com>
Subject: Re: [ath5k-devel] [support] ath5k contention windows
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 9:07 AM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
> On Wed, Sep 15, 2010 at 3:39 AM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Tue, Sep 14, 2010 at 1:51 AM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
>>> as well as 1360 frames which came in with a negative CONTENTION_TIME.
>>>
>>> Ignoring the fact that some frames are coming up with a negative
>>> CONTENTION_TIME (which potentially points to another problem)
>>
>> How negative are these?  Are you subtracting more for, say, txtime
>> than you should be?
>
> Actually, I've found that they were exactly one slot time negative
> (give or take 1us). That said, I was doing these calculations using
> the 802.11a OFDM spec timings. I looked at the driver and realised
> that SIFS is actually being initialised to 14us, whereas it should be
> set to 16us. This will also affect DIFS. Once I take these into
> consideration, they come up as approximately 4-5us out. Now that I
> think about it, it could make sense.
>
> With regards to the tx_time, I'm using the OFDM tx_time formula from
> the 802.11-2007 spec. I'm trying to lock down enough aspects of the
> timing in order to verify it. From what I've seen now, my txtime is
> almost always 4us short, but I can't work out why. I will get the code
> for the txtime when I get into my office, I don't have it on this

The timings I used were from the 802.11-2007 spec.
SIFS, DIFS & Slot Time: Table 17-15—OFDM PHY characteristics
NDPS values: Table 17-3—Modulation-dependent parameters
txtime calculations: Section 17.4.3 OFDM TXTIME calculation

Here are the functions I use to do the basics:
int16_t ndbps(uint8_t rate_Mbps)
{
  //Radiotap returns rate in 500kbps units
  rate_Mbps/=2;

   static const uint8_t rate_nsyms[][2] = {
      {  6,  24 },
      {  9,  36 },
      { 12,  48 },
      { 18,  72 },
      { 24,  96 },
      { 36, 144 },
      { 48, 192 },
      { 54, 216 }
   };
   static const size_t nof_rate_nsyms = sizeof(rate_nsyms) /
sizeof(rate_nsyms[0]);
   for(size_t i = 0; i < nof_rate_nsyms; ++i) {
      if(rate_Mbps == rate_nsyms[i][0]) {
         return rate_nsyms[i][1];
      }
   }
   return -1;
}

int getTXTime(int rate, int noctets) {
  uint16_t usecs = 0;
  const int16_t nof_bps = ndbps(rate);

  int chan_rate = 1;

  if(-1 != nof_bps) {
    const uint16_t preamble = 16 * chan_rate;
    const uint16_t signal = 4 * chan_rate;
    const uint16_t tsym = 4 * chan_rate;
    const uint16_t nsyms = ceill((16.0 + 8.0 * (noctets) + 6.0) / nof_bps);
    usecs = preamble + signal + tsym * nsyms;
  }

  return(usecs);
}
>
>>
>> --
>> Bob Copeland %% www.bobcopeland.com
>>
>
> Thanks,
>
> Jonathan
>

Thanks,


--
Jonathan Guerin
