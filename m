Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:34866 "EHLO
	mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbcGAI7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 04:59:05 -0400
MIME-Version: 1.0
In-Reply-To: <1f44df41-0111-441b-4671-718eec0c4346@broadcom.com>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
 <CAOiHx==82LHOeQMNVD+dybFifXX690Q6AJTcMBMynjSfUOyGUw@mail.gmail.com>
 <8d8bd933-717b-48e4-f002-7b834abed6fd@redhat.com> <3960223.GqB9zXL8s8@wuerfel>
 <1f44df41-0111-441b-4671-718eec0c4346@broadcom.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Fri, 1 Jul 2016 10:58:43 +0200
Message-ID: <CAOiHx=m8Zf0T4=BTG6BMRjj3kOHzt4YaQa3yzutmrhFSOyZMmA@mail.gmail.com> (sfid-20160701_105911_208935_0276989F)
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name
 dt property
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hans de Goede <hdegoede@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Priit Laes <plaes@plaes.org>,
	"John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 30 June 2016 at 21:23, Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>
>
> On 30-6-2016 13:31, Arnd Bergmann wrote:
>> On Thursday, June 30, 2016 12:25:15 PM CEST Hans de Goede wrote:
>>>> So then how about making use of a more specific compatible string?
>>>>
>>>> e.g.
>>>>
>>>> brcmf {
>>>>         compatible = "foo,ap6210", "brcm,bcm4329-fmac";
>>>>         ...
>>>> };
>>>>
>>>> and if the compatible has more than one element you request
>>>> FW_NAME_<compatible>.txt as the nvram file. Or try each comptible (and
>>>> lastly no suffix) until you get a match. (AFAICT, this is what the
>>>> "model" property was originally intended for anyway, but almost nobody
>>>> did it right, and everyone put a user readable string into "model" for
>>>> boards instead of the ePAPR defined compatible string).
>>>
>>> Hmm, interesting idea. Not sure how easy / hard it will be to implement
>>> this, but from a dt binding point of view it seems elegant.
>>>
>>> Kalle, Arend, what do you think of this ?
>
> At first glance I like the suggestion, but this would mean updating the
> bindings document for each new wifi module that we want to add. Not a
> big problem, but it makes that I have a slight preference to using a
> property for it, eg. brcm,module = "ap6210";

If you want a separate property, then I repeat my very first
suggestion, the well defined model property.
e.g.

brcmf@0 {
        model = "ampak,ap6210";
        compatible = "brcm,bcm4329-fmac";
        ...
};

All device nodes may have a model property, not just the top "machine" one.


Regards
Jonas
