Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58697 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbaKDP5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 10:57:16 -0500
Received: by mail-wi0-f180.google.com with SMTP id hi2so9700937wib.7
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 07:57:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415115463.2064.20.camel@sipsolutions.net>
References: <1415114098-25517-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1415115463.2064.20.camel@sipsolutions.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Tue, 4 Nov 2014 16:56:55 +0100
Message-ID: <CAGnRvuo4TzrwSfQF5SUKUKptvFxEeqVTx9zg3KfGnEU=aokyQA@mail.gmail.com> (sfid-20141104_165719_276663_DE445410)
Subject: Re: [PATCH] cfg80211: fix nl80211 cmd id in nl80211_send_mpath()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the only reason why nobody noticed is that the "iw" tool does not even
check the cmd field of the kernel replies it process. I wonder if "iw"
should check the value, just to make sure bugs like this are easier to
detect.

Henning Rogge

On Tue, Nov 4, 2014 at 4:37 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2014-11-04 at 16:14 +0100, Henning Rogge wrote:
>> Netlink command for nl80211_send_mpath() should be NL80211_CMD_NEW_MPATH.
>
> Doh. Applied, of course.
>
> johannes
>
