Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64142 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab1CGSrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 13:47:55 -0500
Received: by vxi39 with SMTP id 39so3963751vxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2011 10:47:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299356769.29845.12.camel@jlt3.sipsolutions.net>
References: <1299288252-28314-2-git-send-email-thomas@cozybit.com>
 <1299356245-13926-1-git-send-email-javier@cozybit.com> <1299356769.29845.12.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 7 Mar 2011 10:47:33 -0800
Message-ID: <AANLkTinFXU+bh=A-qPgQ8oh2GZs7XhPbJe4s3WZMy-0D@mail.gmail.com>
Subject: Re: [PATCH 1/4 v3] mac80211: Enable mesh security from userspace
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 5, 2011 at 12:26 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2011-03-05 at 12:17 -0800, Javier Cardona wrote:
>> Userspace can enable mesh security by providing an RSN IE and setting
>> the MESH_SETUP_ENABLE_SECURITY flag.
>>
>> Also, rename vendor_ie to just ie to reflect that the same attribute may
>> be used to pass other IEs, like for instance RSN.
>>
>> Changes from v2: (from Johannes)
>>  - Fix API backward compatibilty of NL80211_MESH_SETUP_IE
>>  - Remove check for presence of RSN IE
>
> Should be after --- really :-)

Ah, so it stays out of the git commit message, right?  OK.

>> + * @is_secure: or not
>
> Given what we just discussed over in the other thread, should we rename
> this to "userspace_station_mgmt" or something like that?

Are you suggesting to change the name of the flag both in nl80211 and cfg80211?

Currently ENABLE_SECURITY means "let userspace manage stations", but
also "ok to accept mesh management frames from secure mesh peers".
And when the Authenticated Mesh Peering Exchange is implemented, it
will probably mean "verify mesh peering frames in userspace" and
"protect mesh peering frames".  You either do all these tasks or none,
so for nl80211 I would prefer a single flag.

For cfg80211 I have no clear opinion: two flags
(userspace_station_mgmt and is_secure)? one?.  Let me know what makes
more sense to you and we'll do it.

> Also, does it make sense to advertise support for this somehow?
> Otherwise the new tools will have strange failure cases on older
> kernels;

Ah, I see.  Older kernels would not return an error to userspace if an
attempt to set a non existing flag was made, right?
Are you suggesting to define something like an
NL80211_MESHCONF_CAPABILITIES mask?

> and I can also imagine situations where the mesh APIs are in
> firmware or so that can't cope with userspace station mgmt.

Ah mesh in firmware... who would want to do that? :)


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
