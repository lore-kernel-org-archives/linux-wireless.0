Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:37921 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752332AbdATOcp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 09:32:45 -0500
Date: Fri, 20 Jan 2017 15:32:19 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Gabor Juhos <juhosg@openwrt.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Mathias Kresin <dev@kresin.me>,
        Michel Stempin <michel.stempin@wanadoo.fr>,
        John Crispin <blogic@openwrt.org>
Subject: Re: [PATCH v4 0/3] rt2x00: RT5350 support
Message-ID: <20170120143219.GB22861@makrotopia.org> (sfid-20170120_153324_838187_0A7A13FB)
References: <1484918906-21856-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1484918906-21856-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, Jan 20, 2017 at 02:28:23PM +0100, Stanislaw Gruszka wrote:
> Repost patches from Daniel with updated clock handling and
> correct author of RT5350 patch.
> 
> Note I did not test patches on SOC devices, but getting
> clock frequency is simple and should be trouble-free.

Thanks a lot for handling this!
And big thanks to everyone involved for reviewing a smelly pile of
patches we had rotting here for half a decade...

Would you like me to re-work and re-submit the remaining patches needed
to support RT3883 and RF3853?

Otherwise, the next thing I'd have in mind would be to add device-tree
bindings to handle in-flash EEPROM loading, see the patches 60[2-9]* in
https://git.lede-project.org/?p=source.git;a=tree;f=package/kernel/mac80211/patches

Imho having only support for MTD partitions and skip support for
requesting firmware files from userspace for now would be the cleanest
way towards proper WiSoC support in vanilla kernels.
Obviously our existing patches need to be reworked and stuff needs to
be added to Documentation/devicetree/bindings.
Support for non-device-tree legacy platforms which need platform_data
and legacy EEPROM loading mechanism can remain a local patch in our
tree until those will no longer be needed.
Does everybody agree with this general direction?

John, Mathias: Are you going to rework and upstream your work to
support loading in-flash EEPROM yourself our would you like me to give
it a shot?


Cheers


Daniel



> 
> Daniel Golle (1):
>   rt2x00: rt2800lib: add support for RT3352 with 20MHz crystal
> 
> Serge Vasilugin (1):
>   rt2x00: add support for RT5350 WiSoC
> 
> Stanislaw Gruszka (1):
>   rt2x00: add copy of clk for soc devices
> 
>  drivers/net/wireless/ralink/rt2x00/rt2800.h    |   1 +
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 156 +++++++++++++++++++++++--
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h    |   5 +
>  drivers/net/wireless/ralink/rt2x00/rt2x00soc.c |   1 +
>  4 files changed, 155 insertions(+), 8 deletions(-)
> 
> -- 
> 1.8.3.1
> 
