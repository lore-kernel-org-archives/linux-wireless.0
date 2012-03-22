Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42866 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2CVQb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 12:31:57 -0400
Received: by yhmm54 with SMTP id m54so1900088yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Mar 2012 09:31:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201203221133.51928.lindner_marek@yahoo.de>
References: <1332420968-16300-1-git-send-email-yeohchunyeow@gmail.com> <201203221133.51928.lindner_marek@yahoo.de>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 22 Mar 2012 09:31:33 -0700
Message-ID: <CAPjQAd8BAjNFjmpjwrdNMpPNphqTBihitEPEPSiVqzS4KsPEAg@mail.gmail.com> (sfid-20120322_173200_991246_737708CC)
Subject: Re: [PATCH v2] mac80211: fix the RANN propagation issues
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	thomas@cozybit.com, linville@tuxdriver.com,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marek,

On Thu, Mar 22, 2012 at 3:33 AM, Marek Lindner <lindner_marek@yahoo.de> wrote:
>
> Hi,
>
> I am not familiar with the 802.11s code and could be totally wrong here but ..
>
>
> On Thursday, March 22, 2012 13:56:08 Chun-Yeow Yeoh wrote:
>> +       if ((mpath->sn < orig_sn || (mpath->sn == orig_sn &&
>
> .. this sequence number handling looks broken to me. What happens when the
> sequence number wraps around ? One could be smaller than the other and still
> be newer.
> I know this isn't really what your patch changes.
>
>
>>  #define SN_GT(x, y) ((long) (y) - (long) (x) < 0)
>>  #define SN_LT(x, y) ((long) (x) - (long) (y) < 0)
>
> Your macros tried to address the problem but casting your sequence number to
> long also breaks the wrap around.

Ah, thanks for your help.  I guess we do need those macros after all
but they'd have to be re-written as

#define SN_LT(x, y) ((s32)(x - y) < 0)
#define SN_GT(x, y) ((s32)(x - y) > 0)

And since this is just to handle wrap arounds, there is no need for
the new SN_EQ that was suggested earlier.

Cheers,

Javier
