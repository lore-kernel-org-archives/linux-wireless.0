Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:61703 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZCGMDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2009 07:03:33 -0500
MIME-Version: 1.0
In-Reply-To: <1236418002-2189-1-git-send-email-jirislaby@gmail.com>
References: <1236418002-2189-1-git-send-email-jirislaby@gmail.com>
Date: Sat, 7 Mar 2009 14:03:29 +0200
Message-ID: <40f31dec0903070403t20ee10d8y8ef43a622987d519@mail.gmail.com> (sfid-20090307_130342_397449_1C136F18)
Subject: Re: [PATCH 1/2] ath5k: constify stuff
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/7 Jiri Slaby <jirislaby@gmail.com>:
> Make some structures const to place them in .rodata, since we won't
> change them.
>
> Most important parts of objdump -h:
> - =C2=A00 .text =C2=A0 =C2=A0 =C2=A0 =C2=A0 00011170
> + =C2=A00 .text =C2=A0 =C2=A0 =C2=A0 =C2=A0 00011140
> - =C2=A05 .rodata =C2=A0 =C2=A0 =C2=A0 0000828e
> + =C2=A05 .rodata =C2=A0 =C2=A0 =C2=A0 0000895e
> - 13 .data =C2=A0 =C2=A0 =C2=A0 =C2=A0 00000560
> + 13 .data =C2=A0 =C2=A0 =C2=A0 =C2=A0 00000110
> - 14 .devinit.data 00000260
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
> Cc: Bob Copeland <me@bobcopeland.com>
> ---
> =C2=A0drivers/net/wireless/ath5k/attach.c | =C2=A0 13 ++++++-------
> =C2=A0drivers/net/wireless/ath5k/base.c =C2=A0 | =C2=A0 =C2=A08 ++++-=
---
> =C2=A0drivers/net/wireless/ath5k/debug.c =C2=A0| =C2=A0 10 +++++-----
> =C2=A0drivers/net/wireless/ath5k/reset.c =C2=A0| =C2=A0 =C2=A02 +-
> =C2=A04 files changed, 16 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/attach.c b/drivers/net/wirele=
ss/ath5k/attach.c
> index 05bc5cb..656cb9d 100644
> --- a/drivers/net/wireless/ath5k/attach.c
> +++ b/drivers/net/wireless/ath5k/attach.c
> @@ -34,14 +34,14 @@
> =C2=A0static int ath5k_hw_post(struct ath5k_hw *ah)
> =C2=A0{
>
> - =C2=A0 =C2=A0 =C2=A0 int i, c;
> - =C2=A0 =C2=A0 =C2=A0 u16 cur_reg;
> - =C2=A0 =C2=A0 =C2=A0 u16 regs[2] =3D {AR5K_STA_ID0, AR5K_PHY(8)};
> - =C2=A0 =C2=A0 =C2=A0 u32 var_pattern;
> - =C2=A0 =C2=A0 =C2=A0 u32 static_pattern[4] =3D {
> + =C2=A0 =C2=A0 =C2=A0 static const u32 static_pattern[4] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x55555555, =C2=
=A0 =C2=A0 0xaaaaaaaa,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x66666666, =C2=
=A0 =C2=A0 0x99999999
> =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> + =C2=A0 =C2=A0 =C2=A0 static const u16 regs[2] =3D { AR5K_STA_ID0, A=
R5K_PHY(8) };
> + =C2=A0 =C2=A0 =C2=A0 int i, c;
> + =C2=A0 =C2=A0 =C2=A0 u16 cur_reg;
> + =C2=A0 =C2=A0 =C2=A0 u32 var_pattern;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 init_val;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 cur_val;
>
> @@ -106,7 +106,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_sof=
tc *sc, u8 mac_version)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ath5k_hw *ah;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pci_dev *pdev =3D sc->pdev;
> - =C2=A0 =C2=A0 =C2=A0 u8 mac[ETH_ALEN] =3D {};
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 srev;
>
> @@ -312,7 +311,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_sof=
tc *sc, u8 mac_version)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* MAC address is cleared until add_interf=
ace */
> - =C2=A0 =C2=A0 =C2=A0 ath5k_hw_set_lladdr(ah, mac);
> + =C2=A0 =C2=A0 =C2=A0 ath5k_hw_set_lladdr(ah, (u8[ETH_ALEN]){});
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Set BSSID to bcast address: ff:ff:ff:ff=
:ff:ff for now */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(ah->ah_bssid, 0xff, ETH_ALEN);
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless=
/ath5k/base.c
> index 08d691d..780fe6c 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -79,7 +79,7 @@ MODULE_VERSION("0.6.0 (EXPERIMENTAL)");
>
>
> =C2=A0/* Known PCI ids */
> -static struct pci_device_id ath5k_pci_id_table[] __devinitdata =3D {
> +static const struct pci_device_id ath5k_pci_id_table[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ PCI_VDEVICE(ATHEROS, 0x0207), .driver_da=
ta =3D AR5K_AR5210 }, /* 5210 early */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ PCI_VDEVICE(ATHEROS, 0x0007), .driver_da=
ta =3D AR5K_AR5210 }, /* 5210 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ PCI_VDEVICE(ATHEROS, 0x0011), .driver_da=
ta =3D AR5K_AR5211 }, /* 5311 - this is on AHB bus !*/
> @@ -103,7 +103,7 @@ static struct pci_device_id ath5k_pci_id_table[] =
__devinitdata =3D {
> =C2=A0MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
>
> =C2=A0/* Known SREVs */
> -static struct ath5k_srev_name srev_names[] =3D {
> +static const struct ath5k_srev_name srev_names[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "5210", =C2=A0 =C2=A0 =C2=A0 AR5K_VERSIO=
N_MAC, =C2=A0 =C2=A0 =C2=A0 AR5K_SREV_AR5210 },
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "5311", =C2=A0 =C2=A0 =C2=A0 AR5K_VERSIO=
N_MAC, =C2=A0 =C2=A0 =C2=A0 AR5K_SREV_AR5311 },
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "5311A", =C2=A0 =C2=A0 =C2=A0AR5K_VERSIO=
N_MAC, =C2=A0 =C2=A0 =C2=A0 AR5K_SREV_AR5311A },
> @@ -142,7 +142,7 @@ static struct ath5k_srev_name srev_names[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "xxxxx", =C2=A0 =C2=A0 =C2=A0AR5K_VERSIO=
N_RAD, =C2=A0 =C2=A0 =C2=A0 AR5K_SREV_UNKNOWN },
> =C2=A0};
>
> -static struct ieee80211_rate ath5k_rates[] =3D {
> +static const struct ieee80211_rate ath5k_rates[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ .bitrate =3D 10,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.hw_value =3D ATH5K_RATE_CODE_1M, }=
,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ .bitrate =3D 20,
> @@ -248,7 +248,7 @@ static void ath5k_bss_info_changed(struct ieee802=
11_hw *hw,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ieee802=
11_bss_conf *bss_conf,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 changes);
>
> -static struct ieee80211_ops ath5k_hw_ops =3D {
> +static const struct ieee80211_ops ath5k_hw_ops =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.tx =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D ath5k_tx,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.start =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=
 ath5k_start,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.stop =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=
 ath5k_stop,
> diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireles=
s/ath5k/debug.c
> index 413ed68..9770bb3 100644
> --- a/drivers/net/wireless/ath5k/debug.c
> +++ b/drivers/net/wireless/ath5k/debug.c
> @@ -82,14 +82,14 @@ static int ath5k_debugfs_open(struct inode *inode=
, struct file *file)
> =C2=A0/* debugfs: registers */
>
> =C2=A0struct reg {
> - =C2=A0 =C2=A0 =C2=A0 char *name;
> + =C2=A0 =C2=A0 =C2=A0 const char *name;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int addr;
> =C2=A0};
>
> =C2=A0#define REG_STRUCT_INIT(r) { #r, r }
>
> =C2=A0/* just a few random registers, might want to add more */
> -static struct reg regs[] =3D {
> +static const struct reg regs[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0REG_STRUCT_INIT(AR5K_CR),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0REG_STRUCT_INIT(AR5K_RXDP),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0REG_STRUCT_INIT(AR5K_CFG),
> @@ -142,7 +142,7 @@ static struct reg regs[] =3D {
>
> =C2=A0static void *reg_start(struct seq_file *seq, loff_t *pos)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 return *pos < ARRAY_SIZE(regs) ? &regs[*pos] :=
 NULL;
> + =C2=A0 =C2=A0 =C2=A0 return *pos < ARRAY_SIZE(regs) ? (void *)&regs=
[*pos] : NULL;
> =C2=A0}
>
> =C2=A0static void reg_stop(struct seq_file *seq, void *p)
> @@ -153,7 +153,7 @@ static void reg_stop(struct seq_file *seq, void *=
p)
> =C2=A0static void *reg_next(struct seq_file *seq, void *p, loff_t *po=
s)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0++*pos;
> - =C2=A0 =C2=A0 =C2=A0 return *pos < ARRAY_SIZE(regs) ? &regs[*pos] :=
 NULL;
> + =C2=A0 =C2=A0 =C2=A0 return *pos < ARRAY_SIZE(regs) ? (void *)&regs=
[*pos] : NULL;
> =C2=A0}
>
> =C2=A0static int reg_show(struct seq_file *seq, void *p)
> @@ -290,7 +290,7 @@ static const struct file_operations fops_reset =3D=
 {
>
> =C2=A0/* debugfs: debug level */
>
> -static struct {
> +static const struct {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0enum ath5k_debug_level level;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *name;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *desc;
> diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireles=
s/ath5k/reset.c
> index 1531ccd..685dc21 100644
> --- a/drivers/net/wireless/ath5k/reset.c
> +++ b/drivers/net/wireless/ath5k/reset.c
> @@ -102,7 +102,7 @@ static inline int ath5k_hw_write_ofdm_timings(str=
uct ath5k_hw *ah,
> =C2=A0* index into rates for control rates, we can set it up like thi=
s because
> =C2=A0* this is only used for AR5212 and we know it supports G mode
> =C2=A0*/
> -static int control_rates[] =3D
> +static const unsigned int control_rates[] =3D
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ 0, 1, 1, 1, 4, 4, 6, 6, 8, 8, 8, 8 };
>
> =C2=A0/**

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
