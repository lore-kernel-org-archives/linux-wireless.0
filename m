Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58398 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758372Ab2CSW4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 18:56:45 -0400
Received: by bkcik5 with SMTP id ik5so4681424bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 15:56:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120317143640.GC23594@khazad-dum.debian.net>
References: <CAG-2HqUqwHo_xgqC79riQF2DA4DPz1Qy5ZARQK8GT+tf_-UKRg@mail.gmail.com>
	<20120130184446.GB2493@tuxdriver.com>
	<CA++WF2PnEzS5CAfryaPrJSs3Xb3s0WK1zR7N5o8+ud2HiU5GCw@mail.gmail.com>
	<20120315110219.GA2335@redhat.com>
	<CA++WF2P8E=0Xym92MuU84RwaP5Y9uyCyqw5jefh25QDz-Cpzkw@mail.gmail.com>
	<20120317143640.GC23594@khazad-dum.debian.net>
Date: Mon, 19 Mar 2012 15:56:43 -0700
Message-ID: <CA++WF2PCO8ZdhfSMs6_gy2gz5OvTkVrGYXm0X6Aicoe5JmK+pg@mail.gmail.com> (sfid-20120319_235649_060845_A33BEF22)
Subject: Re: MAINTAINER NEEDED -- Re: status of ipw2x00
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Tom Gundersen <teg@jklm.no>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Henrique,

On 17 March 2012 07:36, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Thu, 15 Mar 2012, Stanislav Yakovlev wrote:
>> On 15 March 2012 04:02, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> > Are you plan to fix issues caused on current firmware loading changes on
>> > linux?
>>
>> I was able to reproduce this issue; unfortunately, I don't have a
>> proper fix for it yet.
>
> Maybe you could delay the firmware load to when the device is opened (at
> which point you can probably change the driver to keep the device in PCI
> D3 state unless it is opened, which does save power), and just caching
> the firmware forever after the first load so that you don't need to
> request_firmware anything more than once.
>
> Chances are ipw2xxx firmware will never get a new revision anyway, so
> reloading the modules is not too large a price to pay if the user does
> decide he has to force a firmware refresh...

As far as I know there is no way to force firmware refresh at the
moment without reloading the driver. If you know any implementations
of such behavior, please let me know.

Stanislav.

> --
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh
