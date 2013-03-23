Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54618 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab3CWOqz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 10:46:55 -0400
Message-ID: <514DC055.4070402@hauke-m.de> (sfid-20130323_154701_254001_EB591081)
Date: Sat, 23 Mar 2013 15:46:45 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linville@tuxdriver.com, zajec5@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: use bcma_pmu_spuravoid_pllupdate()
References: <1363885909-12263-1-git-send-email-hauke@hauke-m.de> <CAGRGNgXaZ69o9xNfUih3m4fJQQDT0=C0tLpmYuCVuc4=TAarGw@mail.gmail.com>
In-Reply-To: <CAGRGNgXaZ69o9xNfUih3m4fJQQDT0=C0tLpmYuCVuc4=TAarGw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2013 11:41 PM, Julian Calaby wrote:
> Hi Hauke,
> 
> On Fri, Mar 22, 2013 at 4:11 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> Do not implement this in b43, but use bcma_pmu_spuravoid_pllupdate().
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/net/wireless/b43/phy_n.c |   92 ++++++++------------------------------
>>  1 file changed, 18 insertions(+), 74 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
>> index 3c35382..4130c04 100644
>> --- a/drivers/net/wireless/b43/phy_n.c
>> +++ b/drivers/net/wireless/b43/phy_n.c
>> @@ -5220,19 +5150,33 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
>>
>>         if (dev->phy.rev >= 3 &&
>>             dev->phy.n->spur_avoid != B43_SPUR_AVOID_DISABLE) {
>> -               bool avoid = false;
>> +               struct bcma_drv_cc __maybe_unused *cc;
> 
> Could this go inside the #ifdef in the switch statement - that way the
> __maybe_unused should be unnecessary?

No that is not possible, C forbids it there:

drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_channel_setup’:
drivers/net/wireless/b43/phy_n.c:5169:4: error: a label can only be part
of a statement and a declaration is not a statement

> 
>> +               int avoid = 0;
> 
> I though that bools were converted to ints exactly as you've converted
> the avoid variable here.

Yes I will change that.

Hauke
