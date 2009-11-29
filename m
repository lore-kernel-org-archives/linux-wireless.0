Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:61906 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbZK2O7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 09:59:21 -0500
Message-ID: <4B128C4E.5030008@gmail.com>
Date: Sun, 29 Nov 2009 15:59:26 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
CC: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH v2] rt2x00: Further L2 padding fixes.
References: <1259495278-2264-1-git-send-email-gwingerde@gmail.com> <a32f33a40911290527g3606b740u2713bc64e59d169e@mail.gmail.com> <4B128613.8060906@free.fr>
In-Reply-To: <4B128613.8060906@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/09 15:32, Benoit PAPILLAULT wrote:
> Ivo Van Doorn a écrit :
>> On Sun, Nov 29, 2009 at 12:47 PM, Gertjan van Wingerde
>> <gwingerde@gmail.com> wrote:
>>> Fix a couple of more bugs in the L2 padding code:
>>> 1. Compute the amount of L2 padding correctly (in 3 places).
>>> 2. Trim the skb correctly when the L2 padding has been applied.
>>>
>>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>> ---
>>>
>>> v2:
>>> - Fix bug detect by Benoit Papillault.
>>>
>>> ---
>>>  drivers/net/wireless/rt2x00/rt2x00queue.c |    7 ++++---
>>>  1 files changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
>>> index b8f0954..9082fad 100644
>>> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
>>> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
>>> @@ -181,7 +181,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
>>>        unsigned int frame_length = skb->len;
>>>        unsigned int header_align = ALIGN_SIZE(skb, 0);
>>>        unsigned int payload_align = ALIGN_SIZE(skb, header_length);
>>> -       unsigned int l2pad = 4 - (payload_align - header_align);
>>> +       unsigned int l2pad = (4 - (header_length & 3)) & 3;
>>
>> We already have this calculation on multiple locations, so perhaps it
>> is better to have
>> a L2PAD_SIZE macro in rt2x00.h (where ALIGN_SIZE() is also defined).
>>
>> Ivo
> 
> The formula can be simplified to l2pad = header_length & 3.
> 

Nope. This formula is not correct. It work okay in most cases as header lengths seem
to be even most of the time (maybe even always), and then it doesn't matter, but if
header lengths become uneven, then the formula computes the number of bytes the header
takes in the last 4-byte block, but not the number of padding bytes.

> I'll sent a patch for unpadding on the RX path that I have tested with
> rt2870 usb (I'm still working on the TX path). My feeling is that we are
>  not doing the correct computation.

The current code indeed isn't correct, as it doesn't work for header lengths that don't
need L2 padding. However see above on the problem with your suggested formula.

> 
> l2pad is the number of padding bytes added by the HW. It is computed
> here based on the header_length. However, doing so, we missed two points  :
> 
> 1. ACK frame is 10 bytes. So header_length will be 10 and then l2pad is
> 2. However, ACK frames do not need padding, only DATA frames needs
> padding. The above formula is then wrong.

I gathered as much as well, after a bit of rethinking. However, this is true
because the frame doesn't have a payload at all. That is the part we have to
take into account, not the fact that it is an ACK frame.

> 
> 2. If we receive a QoS DATA frame whose header_length is 26 according to
> frame_control, but skb->len = 20, then ieee80211_get_hdrlen_from_skb()
> will returns hdrlen = 0 based on the value of skb->len. However, this
> function does not know if skb->len includes said padding or not, or some
> other padding! (On RX, rt2870 usb frames are also padded at the end!).

But, in that case we have received an invalid frame anyway, so the padding 
doesn't really matter.

> 
> For those reason, I think it's better to have a common function that
> computes the padding position (based on frame_control). Once we know the
> padding position, we can compute padding size (= padding position & 3,
> like above) and we can also compare with the real frame size (contained
> in RXWI_W0_MPDU_TOTAL_BYTE_COUNT for instance).
> 

See above, I don't think we need to have this detailed knowledge of the frame
formats in the driver.

---
Gertjan.


