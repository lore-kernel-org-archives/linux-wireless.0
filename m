Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.231]:57414 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbXGEMa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2007 08:30:58 -0400
Received: by wx-out-0506.google.com with SMTP id h31so2323878wxd
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2007 05:30:58 -0700 (PDT)
Message-ID: <1ba2fa240707050530q2d165232raa73455397546c62@mail.gmail.com>
Date: Thu, 5 Jul 2007 15:30:58 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: Multiple interfaces in mac80211
Cc: "Jon Smirl" <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200707042305.40944.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
	 <200707042305.40944.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does anybody have/ think of a patch that removes the master interface
from the sub_if_list. It slows down the receive path. Second problem
with this is that the code becomes incorrect when opening receive path
for control packets.  Meanwhile as a workaround I've changed iw_mode
of the master interface  to invalid value instead of default
IEEE80211_IF_TYPE_AP.


On 7/5/07, Michael Wu <flamingice@sourmilk.net> wrote:
> On Wednesday 04 July 2007 17:23, Jon Smirl wrote:
> > I added some debugging code to __ieee80211_rx() and I noticed in this loop:
> >               list_for_each_entry(sdata, &local->sub_if_list, list) {
> >
> sub_if_list includes the master interface.
>
> -Michael Wu
>
>
