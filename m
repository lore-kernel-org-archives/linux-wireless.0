Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62837 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0IIFtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 01:49:10 -0400
Received: by qyk33 with SMTP id 33so1069036qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 22:49:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinhiQAVJKpyjXduVKDqvLXA8EgX7VCFTEu_F272@mail.gmail.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
	<1283988329-44549-5-git-send-email-steve@cozybit.com>
	<AANLkTinhiQAVJKpyjXduVKDqvLXA8EgX7VCFTEu_F272@mail.gmail.com>
Date: Wed, 8 Sep 2010 22:49:09 -0700
Message-ID: <AANLkTikv4N5XHjFw=6UThDji6MumaYbnR+S-95ee0yHS@mail.gmail.com>
Subject: Re: [PATCH 4/9] libertas_tf: Add firmware reset to sdio driver and
 attempt firmware reload
From: Steve deRosier <steve@cozybit.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 8, 2010 at 6:44 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Minor nit:
>
> On Thu, Sep 9, 2010 at 09:25, Steve deRosier <steve@cozybit.com> wrote:
>> This patch adds a method to do a firmware/chip reset to the sdio driver and
>> attempts to reload the firmware.
>>
>> Signed-off-by: Steve deRosier <steve@cozybit.com>
>> ---
>>  drivers/net/wireless/libertas_tf/if_sdio.c |   40 +++++++++++++++++++++++----
>>  drivers/net/wireless/libertas_tf/main.c    |    7 ++++-
>>  2 files changed, 40 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/wireless/libertas_tf/if_sdio.c b/drivers/net/wireless/libertas_tf/if_sdio.c
>> index fed5aff..1e72b4c 100644
>> --- a/drivers/net/wireless/libertas_tf/main.c
>> +++ b/drivers/net/wireless/libertas_tf/main.c
>> @@ -360,7 +364,8 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
>>        return 0;
>>
>>  err_prog_firmware:
>> -//     priv->hw_reset_device(card);
>> +       if (priv->hw_reset_device)
>> +               priv->hw_reset_device(card);
>
> Should this not be done in the first patch? - rather than just
> commenting out the call: Would commenting out this line in the first
> patch make the original version of libertas_tf unable to handle
> firmware errors properly?
>

Yes, it could have been done in the first patch.  I could have rolled
all my patches into one single patch, but I felt it was better to keep
some parts split out.  As it was, I squashed and reordered about 50
commits into the 17 I posted. I basically spent most of the day
rebasing 3 months worth of commits to come out with what I thought was
a logical set.  In particular, since I had contributions from others
in the mix, I wanted to respect their patches as _theirs_ instead of
squashing them into my own.  As you'll notice patch 2 was from someone
else.

If John would prefer, I can squish all my patches into one, with the
exception of those submitted to me by other parties and the lone
mac80211 patch.

As for the specific question about this item...  The libertas_tf_sdio
driver started from the libertas_sdio driver.  I hacked and molded
until I had something that worked and I learned more about the chip
and the interface.  I started by commenting out code I didn't need at
the time.  This specific line was commented out because it wasn't
germane to the problems I was solving at the moment AND it caused
problems.  Did commenting the line out "make the original version of
libertas_tf unable to handle firmware errors properly?" No: simple
fact is resetting the device didn't work properly at the time anyway
and just really mucked up the situation making debugging the firmware
a bear.

If it really matters, I'll be happy to rebase more and send up fewer patches.

Thanks,
- Steve
