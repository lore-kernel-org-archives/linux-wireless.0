Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:10958 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821AbZBRWfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 17:35:00 -0500
Received: by fg-out-1718.google.com with SMTP id 16so1000761fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 14:34:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090218220531.GD4246@tesla>
References: <499C7DC0.4040608@lwfinger.net>
	 <1234992712.4023.60.camel@johannes.local>
	 <20090218220531.GD4246@tesla>
Date: Wed, 18 Feb 2009 23:34:58 +0100
Message-ID: <69e28c910902181434h37a1de57ob86df10d44271fe7@mail.gmail.com> (sfid-20090218_233517_019950_47D8A400)
Subject: Re: ieee80211_regdom module parameter for cfg80211
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 11:05 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Feb 18, 2009 at 01:31:52PM -0800, Johannes Berg wrote:
>> On Wed, 2009-02-18 at 15:29 -0600, Larry Finger wrote:
>> > On at least one forum, I have seen the recommendation that a user set their
>> > regulatory domain by creating the file /etc/modprobe.d/cfg80211 with the
>> > contents "ieee80211_regdom=US".
>> >
>> > That works as long as CONFIG_WIRELESS_OLD_REGULATORY is set in their .config,
>> > but will fail if it is not.
>> >
>> > Should the module_param statement be moved outside the ifdef
>> > CONFIG_WIRELESS_OLD...? Setting the module parameter that way might not make any
>> > sense, but it surely shouldn't kill wireless.
>>
>> I actually see no reason to not just /honour/ it by calling crda with
>> its parameter if CONFIG_WIRELESS_OLD_REGULATORY isn't set.
>
> The idea was that things we want to get rid of will go in OLD_REG. Static regdoms
> for US, JP and EU fall into that and so does the module parameter. I believe
> it is silly to keep the module parameter around as we already have userspace
> APIs to let users set this.

Keeping the module parameter as a way to set the initial regdomain is
helpful for users who upgrade the kernel of an older distro. Adding a
line to /etc/modprobe.d/options would be a much easier way of setting
the right regdomain right during bootup than having to edit the init
scripts, and it is also something that CRDA's "make install" could do
automagically (like "make install regdom=HU").

>
>  Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
