Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37099 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2H0GqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 02:46:06 -0400
Received: by eaac11 with SMTP id c11so1075807eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Aug 2012 23:46:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120827064248.GA22073@ritirata.org>
References: <1346014505-7554-1-git-send-email-ordex@autistici.org>
 <1346014505-7554-2-git-send-email-ordex@autistici.org> <CAGRGNgUoNnuh_23qzULJyJcvMUgNpUxFnZjaAcGj26_jrTHdeA@mail.gmail.com>
 <1346045881.3746.0.camel@jlt4.sipsolutions.net> <CAGRGNgXy3t5TJqY=VwKjPEH=K4XKR_Dm5qVKkmYxStYoAP3fvQ@mail.gmail.com>
 <20120827064248.GA22073@ritirata.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 27 Aug 2012 16:45:44 +1000
Message-ID: <CAGRGNgUnC_A21zp8T35HZQkVtQxTWDY_1nymstPLAo5+zWqF+A@mail.gmail.com> (sfid-20120827_084610_475356_05B87476)
Subject: Re: [PATCHv2 2/2] ath9k_htc: advertise allowed VIFs combination
To: Antonio Quartulli <ordex@autistici.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Antonio,

On Mon, Aug 27, 2012 at 4:42 PM, Antonio Quartulli <ordex@autistici.org> wrote:
> On Mon, Aug 27, 2012 at 03:41:09 +1000, Julian Calaby wrote:
>> Hi Johannes,
>>
>> On Mon, Aug 27, 2012 at 3:38 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Mon, 2012-08-27 at 09:48 +1000, Julian Calaby wrote:
>> >> Antonio,
>> >>
>> >> On Mon, Aug 27, 2012 at 6:55 AM, Antonio Quartulli <ordex@autistici.org> wrote:
>> >> > This driver now advertises its allowed VIFs combinations to the mac80211
>> >> > sublayer.
>> >> >
>> >> > Other than that, practical tests shown that ath9k_htc devices allow an IBSS VIF
>> >> > to coexist with VIF set up on other modes. This patch removes the check which
>> >> > block the creation of any other VIF whenever an IBSS one is already present.
>> >>
>> >> These two patches should really be applied in the opposite order:
>> >>
>> >> You should add the interface combination data (this patch) then remove
>> >> the old checking code.
>> >>
>> >> This way there's not a window (admittedly only one patch) where the
>> >> interface combinations aren't enforced.
>> >
>> > FWIW, it's the other way around, in that window no combinations would be
>> > permitted at all...
>>
>> It's still a problem for bisection then =)
>
> Shall I merge the two patches and do both the changes in one shot?

You might as well, however you should address Mohammed's comment first.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
