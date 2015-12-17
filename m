Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:35635 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934667AbbLQHeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 02:34:13 -0500
Received: by mail-qg0-f48.google.com with SMTP id v36so857364qgd.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 23:34:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450329559.5661.5.camel@perches.com>
References: <1450302215-16156-1-git-send-email-ola1olsson@gmail.com>
	<1450314972.5661.2.camel@perches.com>
	<CABAco3BSaB9R6-nZQsmOnfXXy2ra-un0jjeBkyq4inzCybD5dw@mail.gmail.com>
	<1450329559.5661.5.camel@perches.com>
Date: Thu, 17 Dec 2015 08:34:12 +0100
Message-ID: <CABAco3DCSqzrCZWYXyibV0U1vuTk1En0k505J67vT6eEP2SfEw@mail.gmail.com> (sfid-20151217_083420_983459_6697D40A)
Subject: Re: [PATCH] Print warnings for missing cfg80211_ops implementations
From: Ola Olsson <ola1olsson@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: "ola. olsson" <ola.olsson@sonymobile.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> but maybe it should be
>
>         WARN_ON((ops->add_station && !ops->del_station) ||
>                 (!opt->add_station && ops->del_station))
>
> etc...

Ahh, got it! I really like your idea but I assume it's quite rare to
implement the "stop/del/leave/disconnect" callbacks and at the same
time forget to implement the "start/add/join/connect". You will
probably find out pretty quickly if the "start" functions are missing,
while it might take some time debugging why you lack the "stop"
functions (reinitialization issues/ resource leaks for example).

With that said, don't take my word for it, I was only following the
existing pattern and I assume someone else had a good reason in the
first place.

Best regards,
Ola
