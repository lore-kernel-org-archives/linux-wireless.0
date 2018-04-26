Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:58169 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751155AbeDZBKm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 21:10:42 -0400
Date: Thu, 26 Apr 2018 11:09:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>
Subject: linux-next: manual merge of the wireless-drivers-next tree with the
 wireless-drivers tree
Message-ID: <20180426110917.446204af@canb.auug.org.au> (sfid-20180426_031059_732677_E2CBE3BF)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UVDlBG+DJ+spVUXuLAqoNR7"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/UVDlBG+DJ+spVUXuLAqoNR7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-drivers-next tree got a
conflict in:

  drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c

between commit:

  77e30e10ee28 ("iwlwifi: mvm: query regdb for wmm rule if needed")

from the wireless-drivers tree and commits:

  9c4f7d512740 ("iwlwifi: move all NVM parsing code to the common files")
  4c625c564ba2 ("iwlwifi: get rid of fw/nvm.c")

from the wireless-drivers-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index ca0174680af9,6d33c14579d9..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@@ -978,42 -943,302 +990,333 @@@ iwl_parse_nvm_mcc_info(struct device *d
  	}
 =20
  	regd->n_reg_rules =3D valid_rules;
 +	regd->n_wmm_rules =3D n_wmms;
 =20
 -	/* set alpha2 from FW. */
 -	regd->alpha2[0] =3D fw_mcc >> 8;
 -	regd->alpha2[1] =3D fw_mcc & 0xff;
 +	/*
 +	 * Narrow down regdom for unused regulatory rules to prevent hole
 +	 * between reg rules to wmm rules.
 +	 */
 +	regd_to_copy =3D sizeof(struct ieee80211_regdomain) +
 +		valid_rules * sizeof(struct ieee80211_reg_rule);
 +
 +	wmms_to_copy =3D sizeof(struct ieee80211_wmm_rule) * n_wmms;
 +
 +	copy_rd =3D kzalloc(regd_to_copy + wmms_to_copy, GFP_KERNEL);
 +	if (!copy_rd) {
 +		copy_rd =3D ERR_PTR(-ENOMEM);
 +		goto out;
 +	}
 +
 +	memcpy(copy_rd, regd, regd_to_copy);
 +	memcpy((u8 *)copy_rd + regd_to_copy, (u8 *)regd + size_of_regd,
 +	       wmms_to_copy);
 +
 +	d_wmm =3D (struct ieee80211_wmm_rule *)((u8 *)copy_rd + regd_to_copy);
 +	s_wmm =3D (struct ieee80211_wmm_rule *)((u8 *)regd + size_of_regd);
 +
 +	for (i =3D 0; i < regd->n_reg_rules; i++) {
 +		if (!regd->reg_rules[i].wmm_rule)
 +			continue;
 +
 +		copy_rd->reg_rules[i].wmm_rule =3D d_wmm +
 +			(regd->reg_rules[i].wmm_rule - s_wmm) /
 +			sizeof(struct ieee80211_wmm_rule);
 +	}
 =20
 -	return regd;
 +out:
 +	kfree(regdb_ptrs);
 +	kfree(regd);
 +	return copy_rd;
  }
  IWL_EXPORT_SYMBOL(iwl_parse_nvm_mcc_info);
+=20
+ #define IWL_MAX_NVM_SECTION_SIZE	0x1b58
+ #define IWL_MAX_EXT_NVM_SECTION_SIZE	0x1ffc
+ #define MAX_NVM_FILE_LEN	16384
+=20
+ void iwl_nvm_fixups(u32 hw_id, unsigned int section, u8 *data,
+ 		    unsigned int len)
+ {
+ #define IWL_4165_DEVICE_ID	0x5501
+ #define NVM_SKU_CAP_MIMO_DISABLE BIT(5)
+=20
+ 	if (section =3D=3D NVM_SECTION_TYPE_PHY_SKU &&
+ 	    hw_id =3D=3D IWL_4165_DEVICE_ID && data && len >=3D 5 &&
+ 	    (data[4] & NVM_SKU_CAP_MIMO_DISABLE))
+ 		/* OTP 0x52 bug work around: it's a 1x1 device */
+ 		data[3] =3D ANT_B | (ANT_B << 4);
+ }
+ IWL_EXPORT_SYMBOL(iwl_nvm_fixups);
+=20
+ /*
+  * Reads external NVM from a file into mvm->nvm_sections
+  *
+  * HOW TO CREATE THE NVM FILE FORMAT:
+  * ------------------------------
+  * 1. create hex file, format:
+  *      3800 -> header
+  *      0000 -> header
+  *      5a40 -> data
+  *
+  *   rev - 6 bit (word1)
+  *   len - 10 bit (word1)
+  *   id - 4 bit (word2)
+  *   rsv - 12 bit (word2)
+  *
+  * 2. flip 8bits with 8 bits per line to get the right NVM file format
+  *
+  * 3. create binary file from the hex file
+  *
+  * 4. save as "iNVM_xxx.bin" under /lib/firmware
+  */
+ int iwl_read_external_nvm(struct iwl_trans *trans,
+ 			  const char *nvm_file_name,
+ 			  struct iwl_nvm_section *nvm_sections)
+ {
+ 	int ret, section_size;
+ 	u16 section_id;
+ 	const struct firmware *fw_entry;
+ 	const struct {
+ 		__le16 word1;
+ 		__le16 word2;
+ 		u8 data[];
+ 	} *file_sec;
+ 	const u8 *eof;
+ 	u8 *temp;
+ 	int max_section_size;
+ 	const __le32 *dword_buff;
+=20
+ #define NVM_WORD1_LEN(x) (8 * (x & 0x03FF))
+ #define NVM_WORD2_ID(x) (x >> 12)
+ #define EXT_NVM_WORD2_LEN(x) (2 * (((x) & 0xFF) << 8 | (x) >> 8))
+ #define EXT_NVM_WORD1_ID(x) ((x) >> 4)
+ #define NVM_HEADER_0	(0x2A504C54)
+ #define NVM_HEADER_1	(0x4E564D2A)
+ #define NVM_HEADER_SIZE	(4 * sizeof(u32))
+=20
+ 	IWL_DEBUG_EEPROM(trans->dev, "Read from external NVM\n");
+=20
+ 	/* Maximal size depends on NVM version */
+ 	if (trans->cfg->nvm_type !=3D IWL_NVM_EXT)
+ 		max_section_size =3D IWL_MAX_NVM_SECTION_SIZE;
+ 	else
+ 		max_section_size =3D IWL_MAX_EXT_NVM_SECTION_SIZE;
+=20
+ 	/*
+ 	 * Obtain NVM image via request_firmware. Since we already used
+ 	 * request_firmware_nowait() for the firmware binary load and only
+ 	 * get here after that we assume the NVM request can be satisfied
+ 	 * synchronously.
+ 	 */
+ 	ret =3D request_firmware(&fw_entry, nvm_file_name, trans->dev);
+ 	if (ret) {
+ 		IWL_ERR(trans, "ERROR: %s isn't available %d\n",
+ 			nvm_file_name, ret);
+ 		return ret;
+ 	}
+=20
+ 	IWL_INFO(trans, "Loaded NVM file %s (%zu bytes)\n",
+ 		 nvm_file_name, fw_entry->size);
+=20
+ 	if (fw_entry->size > MAX_NVM_FILE_LEN) {
+ 		IWL_ERR(trans, "NVM file too large\n");
+ 		ret =3D -EINVAL;
+ 		goto out;
+ 	}
+=20
+ 	eof =3D fw_entry->data + fw_entry->size;
+ 	dword_buff =3D (__le32 *)fw_entry->data;
+=20
+ 	/* some NVM file will contain a header.
+ 	 * The header is identified by 2 dwords header as follow:
+ 	 * dword[0] =3D 0x2A504C54
+ 	 * dword[1] =3D 0x4E564D2A
+ 	 *
+ 	 * This header must be skipped when providing the NVM data to the FW.
+ 	 */
+ 	if (fw_entry->size > NVM_HEADER_SIZE &&
+ 	    dword_buff[0] =3D=3D cpu_to_le32(NVM_HEADER_0) &&
+ 	    dword_buff[1] =3D=3D cpu_to_le32(NVM_HEADER_1)) {
+ 		file_sec =3D (void *)(fw_entry->data + NVM_HEADER_SIZE);
+ 		IWL_INFO(trans, "NVM Version %08X\n", le32_to_cpu(dword_buff[2]));
+ 		IWL_INFO(trans, "NVM Manufacturing date %08X\n",
+ 			 le32_to_cpu(dword_buff[3]));
+=20
+ 		/* nvm file validation, dword_buff[2] holds the file version */
+ 		if (trans->cfg->device_family =3D=3D IWL_DEVICE_FAMILY_8000 &&
+ 		    CSR_HW_REV_STEP(trans->hw_rev) =3D=3D SILICON_C_STEP &&
+ 		    le32_to_cpu(dword_buff[2]) < 0xE4A) {
+ 			ret =3D -EFAULT;
+ 			goto out;
+ 		}
+ 	} else {
+ 		file_sec =3D (void *)fw_entry->data;
+ 	}
+=20
+ 	while (true) {
+ 		if (file_sec->data > eof) {
+ 			IWL_ERR(trans,
+ 				"ERROR - NVM file too short for section header\n");
+ 			ret =3D -EINVAL;
+ 			break;
+ 		}
+=20
+ 		/* check for EOF marker */
+ 		if (!file_sec->word1 && !file_sec->word2) {
+ 			ret =3D 0;
+ 			break;
+ 		}
+=20
+ 		if (trans->cfg->nvm_type !=3D IWL_NVM_EXT) {
+ 			section_size =3D
+ 				2 * NVM_WORD1_LEN(le16_to_cpu(file_sec->word1));
+ 			section_id =3D NVM_WORD2_ID(le16_to_cpu(file_sec->word2));
+ 		} else {
+ 			section_size =3D 2 * EXT_NVM_WORD2_LEN(
+ 						le16_to_cpu(file_sec->word2));
+ 			section_id =3D EXT_NVM_WORD1_ID(
+ 						le16_to_cpu(file_sec->word1));
+ 		}
+=20
+ 		if (section_size > max_section_size) {
+ 			IWL_ERR(trans, "ERROR - section too large (%d)\n",
+ 				section_size);
+ 			ret =3D -EINVAL;
+ 			break;
+ 		}
+=20
+ 		if (!section_size) {
+ 			IWL_ERR(trans, "ERROR - section empty\n");
+ 			ret =3D -EINVAL;
+ 			break;
+ 		}
+=20
+ 		if (file_sec->data + section_size > eof) {
+ 			IWL_ERR(trans,
+ 				"ERROR - NVM file too short for section (%d bytes)\n",
+ 				section_size);
+ 			ret =3D -EINVAL;
+ 			break;
+ 		}
+=20
+ 		if (WARN(section_id >=3D NVM_MAX_NUM_SECTIONS,
+ 			 "Invalid NVM section ID %d\n", section_id)) {
+ 			ret =3D -EINVAL;
+ 			break;
+ 		}
+=20
+ 		temp =3D kmemdup(file_sec->data, section_size, GFP_KERNEL);
+ 		if (!temp) {
+ 			ret =3D -ENOMEM;
+ 			break;
+ 		}
+=20
+ 		iwl_nvm_fixups(trans->hw_id, section_id, temp, section_size);
+=20
+ 		kfree(nvm_sections[section_id].data);
+ 		nvm_sections[section_id].data =3D temp;
+ 		nvm_sections[section_id].length =3D section_size;
+=20
+ 		/* advance to the next section */
+ 		file_sec =3D (void *)(file_sec->data + section_size);
+ 	}
+ out:
+ 	release_firmware(fw_entry);
+ 	return ret;
+ }
+ IWL_EXPORT_SYMBOL(iwl_read_external_nvm);
+=20
+ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
+ 				 const struct iwl_fw *fw)
+ {
+ 	struct iwl_nvm_get_info cmd =3D {};
+ 	struct iwl_nvm_get_info_rsp *rsp;
+ 	struct iwl_nvm_data *nvm;
+ 	struct iwl_host_cmd hcmd =3D {
+ 		.flags =3D CMD_WANT_SKB | CMD_SEND_IN_RFKILL,
+ 		.data =3D { &cmd, },
+ 		.len =3D { sizeof(cmd) },
+ 		.id =3D WIDE_ID(REGULATORY_AND_NVM_GROUP, NVM_GET_INFO)
+ 	};
+ 	int  ret;
+ 	bool lar_fw_supported =3D !iwlwifi_mod_params.lar_disable &&
+ 				fw_has_capa(&fw->ucode_capa,
+ 					    IWL_UCODE_TLV_CAPA_LAR_SUPPORT);
+ 	u32 mac_flags;
+ 	u32 sbands_flags =3D 0;
+=20
+ 	ret =3D iwl_trans_send_cmd(trans, &hcmd);
+ 	if (ret)
+ 		return ERR_PTR(ret);
+=20
+ 	if (WARN(iwl_rx_packet_payload_len(hcmd.resp_pkt) !=3D sizeof(*rsp),
+ 		 "Invalid payload len in NVM response from FW %d",
+ 		 iwl_rx_packet_payload_len(hcmd.resp_pkt))) {
+ 		ret =3D -EINVAL;
+ 		goto out;
+ 	}
+=20
+ 	rsp =3D (void *)hcmd.resp_pkt->data;
+ 	if (le32_to_cpu(rsp->general.flags) & NVM_GENERAL_FLAGS_EMPTY_OTP)
+ 		IWL_INFO(trans, "OTP is empty\n");
+=20
+ 	nvm =3D kzalloc(sizeof(*nvm) +
+ 		      sizeof(struct ieee80211_channel) * IWL_NUM_CHANNELS,
+ 		      GFP_KERNEL);
+ 	if (!nvm) {
+ 		ret =3D -ENOMEM;
+ 		goto out;
+ 	}
+=20
+ 	iwl_set_hw_address_from_csr(trans, nvm);
+ 	/* TODO: if platform NVM has MAC address - override it here */
+=20
+ 	if (!is_valid_ether_addr(nvm->hw_addr)) {
+ 		IWL_ERR(trans, "no valid mac address was found\n");
+ 		ret =3D -EINVAL;
+ 		goto err_free;
+ 	}
+=20
+ 	IWL_INFO(trans, "base HW address: %pM\n", nvm->hw_addr);
+=20
+ 	/* Initialize general data */
+ 	nvm->nvm_version =3D le16_to_cpu(rsp->general.nvm_version);
+=20
+ 	/* Initialize MAC sku data */
+ 	mac_flags =3D le32_to_cpu(rsp->mac_sku.mac_sku_flags);
+ 	nvm->sku_cap_11ac_enable =3D
+ 		!!(mac_flags & NVM_MAC_SKU_FLAGS_802_11AC_ENABLED);
+ 	nvm->sku_cap_11n_enable =3D
+ 		!!(mac_flags & NVM_MAC_SKU_FLAGS_802_11N_ENABLED);
+ 	nvm->sku_cap_band_24ghz_enable =3D
+ 		!!(mac_flags & NVM_MAC_SKU_FLAGS_BAND_2_4_ENABLED);
+ 	nvm->sku_cap_band_52ghz_enable =3D
+ 		!!(mac_flags & NVM_MAC_SKU_FLAGS_BAND_5_2_ENABLED);
+ 	nvm->sku_cap_mimo_disabled =3D
+ 		!!(mac_flags & NVM_MAC_SKU_FLAGS_MIMO_DISABLED);
+=20
+ 	/* Initialize PHY sku data */
+ 	nvm->valid_tx_ant =3D (u8)le32_to_cpu(rsp->phy_sku.tx_chains);
+ 	nvm->valid_rx_ant =3D (u8)le32_to_cpu(rsp->phy_sku.rx_chains);
+=20
+ 	if (le32_to_cpu(rsp->regulatory.lar_enabled) && lar_fw_supported) {
+ 		nvm->lar_enabled =3D true;
+ 		sbands_flags |=3D IWL_NVM_SBANDS_FLAGS_LAR;
+ 	}
+=20
+ 	iwl_init_sbands(trans->dev, trans->cfg, nvm,
+ 			rsp->regulatory.channel_profile,
+ 			nvm->valid_tx_ant & fw->valid_tx_ant,
+ 			nvm->valid_rx_ant & fw->valid_rx_ant,
+ 			sbands_flags);
+=20
+ 	iwl_free_resp(&hcmd);
+ 	return nvm;
+=20
+ err_free:
+ 	kfree(nvm);
+ out:
+ 	iwl_free_resp(&hcmd);
+ 	return ERR_PTR(ret);
+ }
+ IWL_EXPORT_SYMBOL(iwl_get_nvm);

--Sig_/UVDlBG+DJ+spVUXuLAqoNR7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlrhJr0ACgkQAVBC80lX
0Gz7EQf9HzxqRBaVAGgaJs60wrU0AN8ZEyWOsmcURhXVQHVfaMLaBabCSrcZJ9H6
Opg+05Su8XcZN5GNcAU2GYUw4xqRGo8TtIk/ObPZccIVtehvKcDXJ11SjF6Q1uKM
ftnOgmZP0nlm8gB8EUmwsh+7DWGyrNqEE/PZVNAP04XJn/l9+PcFTZpTgqVpGIXn
9Kk1RCkvg9bOdt8euID7OxEVVyqs2S8QpomudXmIu7dkuPGWNpnqr1fdmblJiRWE
GqOky+Fyh5yAsVUJCDXPsmoKWoeKEBW077q8Hh7cDkvz1RB57UmBfaYE+qoN/nPy
pBXEQhGhF5XdwyMLO9axg6vG2S5o8A==
=BMEl
-----END PGP SIGNATURE-----

--Sig_/UVDlBG+DJ+spVUXuLAqoNR7--
